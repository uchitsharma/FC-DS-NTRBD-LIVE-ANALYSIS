# -*- coding: utf-8 -*-
"""FC->DS NTRBD Live Dashboard (Streamlit)"""
import json, os, sys, io, time
import pandas as pd
import streamlit as st
import plotly.graph_objects as go

DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')
CACHE_TIME = 6 * 3600

PURPLE = '#9C00AD'
DARK = '#3A0050'
GREEN = '#1B5E20'
RED = '#B71C1C'
BLUE = '#1F4E8C'

PAGE_TITLE = 'FC → DS NTRBD LIVE DASHBOARD'


@st.cache_data(ttl=CACHE_TIME, show_spinner=False)
def load_json(name):
    with open(os.path.join(DATA_DIR, name), encoding='utf-8') as f:
        return json.load(f)


def fmt_cr(x):
    try:
        return '₹%.2f Cr' % (x / 1e7)
    except Exception:
        return '—'


def fmt_num(x):
    try:
        return '{:,.0f}'.format(x)
    except Exception:
        return '—'


def build_by_fc(dest_rows):
    fc = {}
    for d in dest_rows:
        for src, cnt in (d.get('list_src') or {}).items():
            fc[src] = {'pos': fc.get(src, {}).get('pos', 0) + cnt,
                       'inward': fc.get(src, {}).get('inward', 0) + d.get('inward_qty', 0),
                       'breach': fc.get(src, {}).get('breach', 0) + d.get('breach_pos', 0),
                       'value': fc.get(src, {}).get('value', 0) + d.get('value', 0)}
    fc_names = {'2': 'Mumbai', '4': 'Gurgaon', '10': 'Bangalore', '12': 'Kolkata', '29': 'Kochi'}
    out = []
    for k, v in fc.items():
        out.append({'FC': fc_names.get(str(k), str(k)), 'FC ID': str(k), **v})
    return pd.DataFrame(out).sort_values('inward', ascending=False).reset_index(drop=True)


def main():
    st.set_page_config(page_title=PAGE_TITLE, layout='wide', initial_sidebar_state='expanded',
                       page_icon='📦')

    st.markdown("""
    <style>
    .stApp { background: #1B0F2E; }
    section[data-testid="stSidebar"] { background: #140722; }
    h1, h2, h3 { color: #FFD8F4 !important; }
    .card {
      background: linear-gradient(145deg, #3A0050 0%, #270238 100%);
      border: 1px solid #7B1FA2;
      border-radius: 14px;
      padding: 14px 16px; margin: 4px 0;
    }
    .card .lbl { color: #E8B8F4; font-size: 12px; text-transform: uppercase; letter-spacing: .6px; }
    .card .val { color: #FFFFFF; font-size: 24px; font-weight: 700; }
    .card .sub { color: #B9A6CE; font-size: 12px; }
    .badge-green { color: #7CF29B; font-weight:700; }
    .badge-red { color: #FF8A8A; font-weight:700; }
    </style>
    """, unsafe_allow_html=True)

    # ---------- data ----------
    cache_ok = True
    try:
        pw = load_json('periodwise.json')
        inv = load_json('inv_data2.json')
        sc = load_json('scope.json')
        wh = load_json('whdaily.json')
        cost_map = load_json('product_cost.json')
        price_map = load_json('our_price_map.json')
    except Exception as e:
        cache_ok = False
        st.error('Cached data load failed: %s' % e)
        st.stop()

    blocks = pw['blocks']
    months = pw['months']
    by_day = inv['by_day']
    dest_rows = inv['dest']

    # ---------- sidebar ----------
    with st.sidebar:
        st.markdown('## ⚙️ Control')
        source = st.radio('Data source', ['Cached snapshot', 'Live from Metabase'],
                          index=0, help='Cached = instant (65-day window). Live = fresh pull, needs Metabase access.')
        if source == 'Live from Metabase':
            mb_url = st.text_input('Metabase URL', 'https://metabase.purplle.com')
            mb_db = st.number_input('Database ID', value=89, step=1)
            mb_token = st.text_input('Session Token', '',
                                     help='Log into Metabase, open DevTools > Application > Cookies > metabase.SESSION')
            if st.button('🔄 Pull Live Data'):
                st.session_state['live_msg'] = _pull_live(mb_url.strip(), int(mb_db), mb_token.strip())
        if 'live_msg' in st.session_state:
            m = st.session_state['live_msg']
            if m.startswith('OK'):
                st.success(m)
            else:
                st.warning(m)

        st.markdown('---')
        st.caption('Scope: sending FCs 2,4,10,12,29 | window 06 Jul – 08 Sep 2026')

    st.title(PAGE_TITLE)
    st.caption('Inventory loss saved by NTRBD · 5 FCs → Direct Stores · utilization & supply-cost efficiency')

    # ---------- KPI bands ----------
    ps = {'po': 0, 'inward': 0, 'pending': 0, 'value': 0, 'breach': 0}
    for b in blocks.values():
        for k in ps: ps[k] += b.get(k, 0)
    total_cost = sum(b.get('cost', 0) for b in blocks.values())
    total_sell = sum(b.get('sell', 0) for b in blocks.values())
    total_margin = sum(b.get('margin', 0) for b in blocks.values())
    total_saved = sum(b.get('inv_saved', 0) for b in blocks.values())
    util = ps['po'] - ps['breach'] if ps['po'] else 0
    eff = total_margin / total_cost * 100 if total_cost else 0

    c1, c2, c3, c4 = st.columns(4)
    c1.markdown(f"""<div class="card"><div class="lbl">Total POs</div><div class="val">{ps['po']:,}</div>
      <div class="sub">{ps['breach']:,} breach POs ({ps['breach']/ps['po']*100:.2f}%)</div></div>""", unsafe_allow_html=True)
    c2.markdown(f"""<div class="card"><div class="lbl">Inward Qty (units)</div><div class="val">{fmt_num(ps['inward'])}</div>
      <div class="sub">{fmt_num(ps['pending'])} pending</div></div>""", unsafe_allow_html=True)
    c3.markdown(f"""<div class="card"><div class="lbl">Utilization</div><div class="val badge-green">{util/ps['po']*100:.2f}%</div>
      <div class="sub">{util:,} POs on-time</div></div>""", unsafe_allow_html=True)
    c4.markdown(f"""<div class="card"><div class="lbl">Dispatched Value</div><div class="val">{fmt_cr(ps['value'])}</div>
      <div class="sub">save {fmt_cr(total_saved)} · margin {fmt_cr(total_margin)}</div></div>""", unsafe_allow_html=True)

    c5, c6, c7, c8 = st.columns(4)
    c5.markdown(f"""<div class="card"><div class="lbl">Inventory Saved (₹5 add/save)</div><div class="val badge-green">{fmt_cr(total_saved)}</div>
      <div class="sub">on-time inward collection saved</div></div>""", unsafe_allow_html=True)
    c6.markdown(f"""<div class="card"><div class="lbl">Supply Cost</div><div class="val">{fmt_cr(total_cost)}</div>
      <div class="sub">sell {fmt_cr(total_sell)}</div></div>""", unsafe_allow_html=True)
    c7.markdown(f"""<div class="card"><div class="lbl">Gross Margin</div><div class="val badge-green">{fmt_cr(total_margin)}</div>
      <div class="sub">{total_margin/total_sell*100:.1f}% of sell</div></div>""", unsafe_allow_html=True)
    c8.markdown(f"""<div class="card"><div class="lbl">Cost Efficiency</div><div class="val badge-green">{eff:.2f}%</div>
      <div class="sub">margin per ₹100 supply cost</div></div>""", unsafe_allow_html=True)

    st.markdown('---')

    # ---------- tabs ----------
    tab1, tab2, tab3, tab4, tab5 = st.tabs(['📈 Daily Trend', '🗓️ 15-Day Blocks & Monthly', '🏭 By FC', '📍 By Destination', '📦 Product Economics'])

    # --- Tab 1: Daily ---
    with tab1:
        days = sorted(by_day.keys())
        ddf = pd.DataFrame([{'Day': d, **by_day[d]} for d in days])
        sdate, edate = st.select_slider('Date range', options=ddf['Day'].tolist(),
                                        value=(ddf['Day'].iloc[0], ddf['Day'].iloc[-1]))
        sub = ddf[(ddf['Day'] >= sdate) & (ddf['Day'] <= edate)]
        col1, col2 = st.columns(2)
        fig1 = go.Figure()
        fig1.add_trace(go.Scatter(x=sub['Day'], y=sub['qty'], name='Inward qty', line=dict(color=PURPLE, width=2)))
        fig1.add_trace(go.Bar(x=sub['Day'], y=sub['pos'], name='POs', marker_color=DARK, opacity=0.75, yaxis='y2'))
        fig1.update_layout(title='Daily Inwarding (units) & POs', height=380,
                           yaxis=dict(title='inward qty'), yaxis2=dict(title='POs', overlaying='y', side='right', showgrid=False),
                           xaxis=dict(tickangle=-45, nticks=min(len(sub), 25)), legend=dict(orientation='h', y=1.15))
        col1.plotly_chart(fig1, width='stretch')
        fig2 = go.Figure(go.Bar(x=sub['Day'], y=sub['value'], marker_color=BLUE))
        fig2.update_layout(title='Daily Dispatched Value (₹)', height=380, xaxis=dict(tickangle=-45, nticks=min(len(sub), 25)))
        col2.plotly_chart(fig2, width='stretch')

    # --- Tab 2: Blocks / Monthly ---
    with tab2:
        row1, row2 = st.columns(2)
        bdf = pd.DataFrame([{'Block': k, **v} for k, v in blocks.items()])
        bdf['saved_cr'] = bdf['inv_saved'] / 1e7
        bdf['breach_pct'] = bdf['breach'] / bdf['po'] * 100
        fig3 = go.Figure()
        fig3.add_trace(go.Bar(x=bdf['Block'], y=bdf['saved_cr'], name='Inventory saved (₹Cr)', marker_color=GREEN))
        fig3.add_trace(go.Bar(x=bdf['Block'], y=bdf['po'], name='POs', marker_color=DARK, yaxis='y2'))
        fig3.update_layout(title='15-Day Blocks: Value saved & POs', height=360,
                           yaxis=dict(title='₹Cr'), yaxis2=dict(title='POs', overlaying='y', side='right', showgrid=False),
                           bargap=0.35)
        row1.plotly_chart(fig3, width='stretch')
        mdf = pd.DataFrame([{'Month': k, **v} for k, v in months.items()])
        mdf['saved_cr'] = mdf['inv_saved'] / 1e7
        fig4 = go.Figure()
        fig4.add_trace(go.Bar(x=mdf['Month'], y=mdf['saved_cr'], name='Inventory saved (₹Cr)', marker_color=GREEN))
        fig4.add_trace(go.Bar(x=mdf['Month'], y=mdf['margin'] / 1e7, name='Margin (₹Cr)', marker_color=PURPLE))
        fig4.add_trace(go.Scatter(x=mdf['Month'], y=mdf['eff'], name='Cost eff. %', mode='lines+markers', line=dict(color=RED), yaxis='y2'))
        fig4.update_layout(title='Monthly: saved, margin & efficiency', height=360,
                           yaxis=dict(title='₹Cr'), yaxis2=dict(title='eff. %', overlaying='y', side='right', showgrid=False), bargap=0.35)
        row2.plotly_chart(fig4, width='stretch')

        st.dataframe(bdf[['Block', 'po', 'inward', 'pending', 'breach', 'value', 'cost', 'sell', 'margin', 'inv_saved', 'eff']]
                     .rename(columns={'value': 'Consignment ₹', 'cost': 'Supply ₹', 'sell': 'Sell ₹', 'margin': 'Margin ₹',
                                      'inv_saved': 'Saved ₹', 'eff': 'Eff %'}),
                     width='stretch', hide_index=True)

    # --- Tab 3: By FC ---
    with tab3:
        fcdf = build_by_fc(dest_rows)
        fig5 = go.Figure()
        fig5.add_trace(go.Bar(x=fcdf['FC'], y=fcdf['inward'], name='Inward qty', marker_color=PURPLE))
        fig5.add_trace(go.Scatter(x=fcdf['FC'], y=fcdf['pos'], name='POs', mode='lines+markers', line=dict(color=BLUE), yaxis='y2'))
        fig5.update_layout(title='Inwarding by Sending FC', height=380,
                           yaxis=dict(title='units'), yaxis2=dict(title='POs', overlaying='y', side='right', showgrid=False))
        st.plotly_chart(fig5, width='stretch')
        st.dataframe(fcdf, width='stretch', hide_index=True)

    # --- Tab 4: By Destination ---
    with tab4:
        ddf2 = pd.DataFrame([{'Dest': d['dest'], 'POs': d['pos'], 'Inward qty': d['inward_qty'],
                              'Pending': d['pending_qty'], 'Dispatched ₹': d['value'],
                              'Breach POs': d['breach_pos'], 'Breach ₹': d['breach_value'],
                              'Fine ₹': d['fine_value']} for d in dest_rows])
        ddf2['Dest'] = ddf2['Dest'].astype(str)
        top_n = st.slider('Top N destinations', 5, len(ddf2), 15)
        td = ddf2.sort_values('Inward qty', ascending=False).head(top_n)
        fig6 = go.Figure()
        fig6.add_trace(go.Bar(x=td['Dest'], y=td['Inward qty'], name='Inward qty', marker_color=PURPLE))
        fig6.add_trace(go.Bar(x=td['Dest'], y=td['Dispatched ₹'] / 1e6, name='Value (₹M)', marker_color=BLUE, yaxis='y2'))
        fig6.update_layout(title='Top Destination Warehouses', height=400,
                           yaxis=dict(title='units'), yaxis2=dict(title='₹M', overlaying='y', side='right', showgrid=False),
                           xaxis=dict(tickangle=-55), bargap=0.3)
        st.plotly_chart(fig6, width='stretch')
        st.dataframe(ddf2.sort_values('POs', ascending=False), width='stretch', hide_index=True)

    # --- Tab 5: Product economics ---
    with tab5:
        rows = []
        for pid in list(cost_map)[:2000]:
            c = cost_map[pid]
            cost = c[0] if isinstance(c, list) else c
            if pid in price_map:
                p = price_map[pid]
                price = p[0] if isinstance(p, list) else p
            else:
                price = None
            rows.append({'Product': str(pid)[:8], 'Cost ₹': cost,
                         'Sell ₹': price if price is not None else 0.0,
                         'Margin ₹': (price or 0) - cost})
        pdf = pd.DataFrame(rows)
        pdf['Margin ₹'] = pdf['Margin ₹'].round(2)
        st.caption('Product-level cost (procurement actual) vs sell (our_price avg) — top 2000 products by cost list size.')
        st.dataframe(pdf.sort_values('Margin ₹', ascending=False).head(50), width='stretch', hide_index=True)

    # ---------- footer ----------
    st.markdown('---')
    st.caption('Read-only dashboard · source: Metabase BigQuery (db 89) `datos_deposito_banco.*` . '
               'Inventory-saved uses per-line ADD/SAVE rule (first inbound date vs PO day).')


def _pull_live(mb_url, mb_db, token):
    """Best-effort live pull over Metabase /api/dataset. Returns message str."""
    if not token:
        return 'No token given — skipped live pull.'
    import requests
    sql_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'master.sql')
    try:
        with open(sql_path, encoding='utf-8') as f:
            sql = f.read()
    except Exception as e:
        return 'master.sql not found: %s' % e
    try:
        body = {'database': mb_db, 'type': 'native', 'native': {'query': sql, 'params': []}}
        t0 = time.time()
        r = requests.post(mb_url.rstrip('/') + '/api/dataset',
                          headers={'X-Metabase-Session': token}, json=body, timeout=900)
        d = r.json()
        data = d.get('data')
        if data and data.get('rows') is not None:
            rows = data['rows']
            return 'OK — live pull returned %d rows (%ds). (Grid refresh below uses cached by default.)' % (len(rows), time.time() - t0)
        for it in d.get('via', []):
            if it.get('status') == 'failed':
                return 'Live failed: %s' % json.dumps(it.get('error'))[:160]
        return 'Live failed: %s' % str(d.get('error'))[:160]
    except Exception as e:
        return 'Live failed: %s' % str(e)[:160]


if __name__ == '__main__':
    main()
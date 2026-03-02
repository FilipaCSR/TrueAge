# =============================================================================
# CSS STYLES
# =============================================================================
# Apple-inspired minimalist design
# =============================================================================

apple_css <- "
/* Import SF Pro-like font */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

* {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  -webkit-font-smoothing: antialiased;
}

body {
  background: #F8F7F4;
  min-height: 100vh;
}

.container-fluid {
  max-width: 1400px;
  margin: 0 auto;
  padding: 16px 20px;
}

/* Footer */
.app-footer {
  text-align: center;
  padding: 20px;
  margin-top: 24px;
  border-top: 1px solid #e5e5e7;
}

.app-footer p {
  font-size: 12px;
  color: #86868b;
  margin: 0;
}

.app-footer a {
  color: #1C4A3E;
  text-decoration: none;
}

.app-footer a:hover {
  text-decoration: underline;
}

/* Header - Premium */
.app-header {
  text-align: center;
  padding: 16px 32px 12px;
  margin: 0 0 20px 0;
  background: #ffffff;
  border: 1px solid #EBEBEB;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.header-tabs {
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid #EBEBEB;
}

.app-header .nav-tabs {
  border-bottom: none;
  justify-content: center;
  gap: 6px;
}

.app-header .nav-tabs > li > a {
  color: #86868b;
  font-weight: 500;
  font-size: 13px;
  padding: 8px 20px;
  border-radius: 6px;
  border: none;
  background: transparent;
  transition: all 0.2s ease;
}

.app-header .nav-tabs > li > a:hover {
  color: #1B3A5C;
  background: rgba(27, 58, 92, 0.08);
  border: none;
}

.app-header .nav-tabs > li.active > a,
.app-header .nav-tabs > li.active > a:hover,
.app-header .nav-tabs > li.active > a:focus {
  color: #ffffff;
  background: #1B3A5C;
  border: none;
  box-shadow: 0 2px 6px rgba(27, 58, 92, 0.25);
}

.app-header .tab-content {
  text-align: left;
  margin-top: 16px;
  margin-left: -32px;
  margin-right: -32px;
  margin-bottom: -12px;
  padding: 0 32px;
  background: #F8F7F4;
  border-radius: 0 0 12px 12px;
}

.app-header .tab-pane {
  padding-top: 0;
}

.app-title {
  font-size: 28px;
  font-weight: 700;
  color: #1d1d1f;
  letter-spacing: -0.3px;
  margin: 0;
}

.app-subtitle {
  font-size: 12px;
  font-weight: 400;
  color: #86868b;
  margin: 4px 0 0 0;
  letter-spacing: 0.2px;
}

/* Cards - Compact */
.apple-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  border: 1px solid #EBEBEB;
}

.apple-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.apple-card-title {
  font-size: 18px;
  font-weight: 600;
  color: #1d1d1f;
  margin-bottom: 12px;
  letter-spacing: -0.2px;
}

/* Input styling - Compact */
.form-group {
  margin-bottom: 10px;
}

.control-label {
  font-size: 12px;
  font-weight: 500;
  color: #1d1d1f;
  margin-bottom: 4px;
}

.form-control, .selectize-input {
  border: 1px solid #d2d2d7 !important;
  border-radius: 10px !important;
  padding: 10px 12px !important;
  font-size: 14px !important;
  transition: border-color 0.2s ease, box-shadow 0.2s ease !important;
  background: #ffffff !important;
  height: 42px !important;
  min-height: 42px !important;
  box-sizing: border-box !important;
}

.selectize-input {
  display: flex !important;
  align-items: center !important;
}

.form-control:focus, .selectize-input.focus {
  border-color: #1B3A5C !important;
  box-shadow: 0 0 0 3px rgba(27, 58, 92, 0.1) !important;
  outline: none !important;
}

/* Button styling - Compact */
.btn-calculate {
  background: linear-gradient(180deg, #2a4d75 0%, #1B3A5C 100%);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 14px 24px;
  font-size: 15px;
  font-weight: 600;
  width: 100%;
  cursor: pointer;
  transition: all 0.2s ease;
  letter-spacing: -0.2px;
  margin-top: 8px;
}

.btn-calculate:hover {
  background: linear-gradient(180deg, #0077ed 0%, #005bb5 100%);
  transform: scale(1.01);
  box-shadow: 0 4px 16px rgba(0, 113, 227, 0.4);
}

.btn-calculate:active {
  transform: scale(0.99);
}

/* Results display - Compact Square */
.result-box {
  width: 130px;
  height: 130px;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin: 0 auto 12px;
  position: relative;
}

.result-box-green {
  background: linear-gradient(135deg, #1C4A3E 0%, #2D7A5F 100%);
  box-shadow: 0 6px 24px rgba(45, 122, 95, 0.3);
}

.result-box-yellow {
  background: linear-gradient(135deg, #7a7a7a 0%, #8C8C8C 100%);
  box-shadow: 0 6px 24px rgba(140, 140, 140, 0.3);
}

.result-box-red {
  background: linear-gradient(135deg, #a54d1f 0%, #C4622D 100%);
  box-shadow: 0 6px 24px rgba(196, 98, 45, 0.3);
}

.result-number {
  font-size: 42px;
  font-weight: 700;
  color: white;
  line-height: 1;
}

.result-label {
  font-size: 12px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  margin-top: 2px;
}

/* Results row - 3 aligned boxes */
.results-row {
  display: flex;
  justify-content: center;
  align-items: stretch;
  gap: 16px;
  margin-bottom: 16px;
}

.result-tile {
  flex: 1;
  max-width: 160px;
  min-height: 140px;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px 16px;
  text-align: center;
}

.result-tile-primary {
  background: linear-gradient(135deg, #1B3A5C 0%, #2a4d75 100%);
  box-shadow: 0 6px 20px rgba(27, 58, 92, 0.25);
}

.result-tile-green {
  background: linear-gradient(135deg, #1C4A3E 0%, #2D7A5F 100%);
  box-shadow: 0 6px 20px rgba(45, 122, 95, 0.25);
}

.result-tile-yellow {
  background: linear-gradient(135deg, #7a7a7a 0%, #8C8C8C 100%);
  box-shadow: 0 6px 20px rgba(140, 140, 140, 0.25);
}

.result-tile-red {
  background: linear-gradient(135deg, #a54d1f 0%, #C4622D 100%);
  box-shadow: 0 6px 20px rgba(196, 98, 45, 0.25);
}

.result-tile-neutral {
  background: #F8F7F4;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
}

.tile-value {
  font-size: 36px;
  font-weight: 700;
  color: white;
  line-height: 1;
  margin-bottom: 4px;
}

.tile-value-dark {
  color: #1d1d1f;
}

.tile-unit {
  font-size: 14px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.85);
  margin-bottom: 8px;
}

.tile-unit-dark {
  color: #86868b;
}

.tile-label {
  font-size: 11px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.tile-label-dark {
  color: #86868b;
}

/* Legacy stat cards */
.stat-card {
  text-align: center;
  padding: 12px 8px;
  background: #f5f5f7;
  border-radius: 12px;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1d1d1f;
  margin-bottom: 2px;
}

.stat-label {
  font-size: 10px;
  font-weight: 500;
  color: #86868b;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-positive { color: #2D7A5F; }
.stat-negative { color: #C4622D; }
.stat-neutral { color: #8C8C8C; }

/* Section headers - Compact */
.section-header {
  font-size: 22px;
  font-weight: 600;
  color: #1d1d1f;
  margin: 20px 0 12px;
  letter-spacing: -0.3px;
}

.section-subheader {
  font-size: 14px;
  color: #86868b;
  margin-bottom: 16px;
  line-height: 1.4;
}

/* Recommendation cards - Compact */
.recommendation-card {
  background: #f5f5f7;
  border-radius: 12px;
  padding: 14px;
  margin-bottom: 8px;
}

.recommendation-title {
  font-size: 14px;
  font-weight: 600;
  color: #1d1d1f;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.recommendation-badge {
  font-size: 9px;
  font-weight: 600;
  padding: 3px 8px;
  border-radius: 20px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.badge-high {
  background: #fae8e0;
  color: #C4622D;
}

.badge-low {
  background: #e2f0eb;
  color: #2D7A5F;
}

.recommendation-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.recommendation-list li {
  padding: 4px 0;
  padding-left: 18px;
  position: relative;
  font-size: 13px;
  color: #1d1d1f;
  line-height: 1.4;
}

.recommendation-list li::before {
  content: '→';
  position: absolute;
  left: 0;
  color: #1C4A3E;
  font-weight: 600;
}

/* Tabs - Compact */
.nav-tabs {
  border: none;
  background: #f5f5f7;
  border-radius: 10px;
  padding: 3px;
  display: inline-flex;
  margin-bottom: 16px;
}

.nav-tabs > li > a {
  border: none !important;
  border-radius: 8px !important;
  padding: 8px 20px !important;
  font-size: 13px !important;
  font-weight: 500 !important;
  color: #1d1d1f !important;
  background: transparent !important;
  transition: all 0.2s ease !important;
}

.nav-tabs > li.active > a,
.nav-tabs > li > a:hover {
  background: #ffffff !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
}

/* Info grid - Compact */
.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 12px;
}

/* Plot styling */
.plot-container {
  background: #ffffff;
  border-radius: 16px;
  padding: 24px;
}

/* Comparison section - CSS Grid for perfect alignment */
.comparison-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 16px;
}

.comparison-row .apple-card {
  margin-bottom: 0;
  height: 500px;
  display: flex;
  flex-direction: column;
}

.comparison-row .apple-card-title {
  margin-bottom: 12px;
  flex-shrink: 0;
}

.comparison-row .shiny-plot-output {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.comparison-row .dataTables_wrapper {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}

.comparison-row .table-legend {
  flex-shrink: 0;
  font-size: 10px;
  color: #86868b;
  margin-top: -4px;
  margin-bottom: 8px;
}

.comparison-row table.dataTable {
  width: 100% !important;
  font-size: 12px;
}

.comparison-row table.dataTable thead th {
  background: #f5f5f7;
  color: #1d1d1f;
  font-weight: 600;
  padding: 5px 8px;
  border: none;
}

.comparison-row table.dataTable thead th:first-child {
  text-align: left;
}

.comparison-row table.dataTable thead th:not(:first-child) {
  text-align: right;
}

.comparison-row table.dataTable tbody td {
  padding: 4px 8px;
  border-bottom: 1px solid #f5f5f7;
  color: #1d1d1f;
}

.comparison-row table.dataTable tbody td:not(:first-child) {
  text-align: right;
}

.comparison-row table.dataTable tbody tr:hover {
  background: #fafafa;
}

@media (max-width: 900px) {
  .comparison-row {
    grid-template-columns: 1fr;
  }
}

/* Hide default Shiny styling */
.shiny-input-container {
  width: 100% !important;
}

/* Responsive */
@media (max-width: 768px) {
  .app-title { font-size: 24px; }
  .app-subtitle { font-size: 13px; }
  .apple-card { padding: 16px; border-radius: 12px; }
  .result-ring { width: 120px; height: 120px; }
  .result-number { font-size: 36px; }
}

/* Data table styling - Compact */
.dataTables_wrapper {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif !important;
}

table.dataTable {
  border-collapse: collapse !important;
  border: none !important;
}

table.dataTable thead th {
  background: #f5f5f7 !important;
  border: none !important;
  font-weight: 600 !important;
  font-size: 11px !important;
  color: #86868b !important;
  text-transform: uppercase !important;
  letter-spacing: 0.5px !important;
  padding: 10px 8px !important;
}

table.dataTable tbody td {
  border: none !important;
  border-bottom: 1px solid #f5f5f7 !important;
  padding: 10px 8px !important;
  font-size: 13px !important;
  color: #1d1d1f !important;
}

table.dataTable tbody tr:hover {
  background: #f5f5f7 !important;
}

/* Hide pagination */
.dataTables_paginate, .dataTables_info, .dataTables_length, .dataTables_filter {
  display: none !important;
}
"

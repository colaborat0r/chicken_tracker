# Optional Report Metrics - Visual Implementation Guide

## User Journey

```
┌─────────────────────────────────────────────────────────────────────┐
│                    HOME SCREEN                                       │
│ ┌──────────────────────────────────────────────────────────────┐   │
│ │ [☰ DRAWER]                                                   │   │
│ │  Home                                                         │   │
│ │  ───────────────────────────────────────────────────────     │   │
│ │  Flock                                                        │   │
│ │  · View Flock                                                 │   │
│ │  · Flock Purchases                                            │   │
│ │  · Flock Losses                                               │   │
│ │  ───────────────────────────────────────────────────────     │   │
│ │  Production                                                   │   │
│ │  · Log Egg Production                                         │   │
│ │  · Production History                                         │   │
│ │  · Analytics                                                  │   │
│ │  ───────────────────────────────────────────────────────     │   │
│ │  Finance                                                      │   │
│ │  · Sales                                                      │   │
│ │  · Expenses                                                   │   │
│ │  ───────────────────────────────────────────────────────     │   │
│ │  · Reports & Exports  ✨ Farm Report Button                  │   │
│ │  ───────────────────────────────────────────────────────     │   │
│ │  Care                                                         │   │
│ │  · Reminders                                                  │   │
│ │  · Tips / Guides                                              │   │
│ │  ───────────────────────────────────────────────────────     │   │
│ │  Settings                                                     │   │
│ │  🔧 Farm Report Settings  ◄──── NEW MENU ITEM               │   │
│ │  🛠️  Data Management                                          │   │
│ │ └──────────────────────────────────────────────────────────┘   │
│                                                                     │
│  [Quick Actions]  [Farm Snapshot]  [Daily Stats]  [Tips]  ...    │
└─────────────────────────────────────────────────────────────────────┘
                            ↓ (tap menu item)
                            ↓
┌─────────────────────────────────────────────────────────────────────┐
│              FARM REPORT SETTINGS SCREEN (NEW)                      │
├─────────────────────────────────────────────────────────────────────┤
│ < Farm Report Settings                                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│ Monthly Snapshot Metrics                                            │
│                                                                     │
│ Choose which metrics to display on your Farm Report Cards.         │
│ "Profit/Loss" and "Feed per Egg" are disabled by default.         │
│                                                                     │
│ ☑ 🥚 Total Eggs                                                    │
│    Total eggs collected this month                                 │
│                                                                     │
│ ☑ 💰 Total Sales                                                   │
│    Total sales revenue this month                                  │
│                                                                     │
│ ☑ 💸 Total Expenses                                                │
│    Total farm expenses this month                                  │
│                                                                     │
│ ☐ 📊 Profit/Loss                    ← DISABLED BY DEFAULT         │
│    Net profit or loss for the month                                │
│                                                                     │
│ ☑ 🐔 Flock Count                                                   │
│    Current number of chickens                                      │
│                                                                     │
│ ☑ 🥚 Laying Hens                                                   │
│    Number of hens currently laying                                 │
│                                                                     │
│ ☐ 🌾 Feed per Egg                   ← DISABLED BY DEFAULT         │
│    Average feed cost per egg                                       │
│                                                                     │
│ ☑ 📈 Laying %                                                      │
│    Percentage of flock that is laying                              │
│                                                                     │
│ ┌─────────────────────────────────────────────────────────┐       │
│ │ [Reset to Defaults] 🔄                                  │       │
│ └─────────────────────────────────────────────────────────┘       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
       ↓ (user toggles metrics)          ↓ (then generates report)
       ↓ (auto-saves)
       ↓
┌─────────────────────────────────────────────────────────────────────┐
│              GENERATED FARM REPORT PDF (CONDITIONAL)                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│ ┌───────────────────────────────────────────────────────────────┐ │
│ │  Sunny Acres Farm              April 2026                    │ │
│ │  Monthly Farm Report           Generated Apr 22, 2026        │ │
│ └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│ MONTHLY SNAPSHOT                                                    │
│                                                                     │
│ ┌────────────┬────────────┬────────────┬────────────┐             │
│ │ 🥚 Eggs    │ 💰 Sales   │ 💸 Expenses│ 🐔 Flock   │             │
│ │ 287        │ $156.50    │ $48.30     │ 24         │             │
│ │ collected  │ revenue    │ spent      │ birds      │             │
│ └────────────┴────────────┴────────────┴────────────┘             │
│                                                                     │
│ ┌────────────┬────────────┬────────────┐                          │
│ │ 🥚 Layers  │ 📈 Lay %   │            │                          │
│ │ 21         │ 87%        │            │                          │
│ │ laying     │ active     │            │                          │
│ └────────────┴────────────┴────────────┘                          │
│                                                                     │
│ (Note: Profit/Loss and Feed per Egg NOT shown - disabled)         │
│                                                                     │
│ DAILY PRODUCTION - April 2026                                      │
│ [BAR CHART VISUALIZATION]                                         │
│                                                                     │
│                                                                     │
│ 🐓 Generated by Chicken Tracker          Sunny Acres Farm         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## State Management Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   RIVERPOD PROVIDER CHAIN                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  reportSettingsProvider (StateNotifierProvider<ReportSettings>)│
│         ↓                                                       │
│  ReportSettingsNotifier (manages state)                       │
│         ↓                                                       │
│  ReportSettings (immutable model)                             │
│         ↓                                                       │
│  SharedPreferences (persistence)                              │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │ Key: 'report_enabled_metrics'                           │  │
│  │ Value: [                                                │  │
│  │   'totalEggs:true',                                     │  │
│  │   'totalSales:true',                                    │  │
│  │   'totalExpenses:true',                                 │  │
│  │   'profitLoss:false',                                   │  │
│  │   'flockCount:true',                                    │  │
│  │   'layingCount:true',                                   │  │
│  │   'feedPerEgg:false',                                   │  │
│  │   'layingPercentage:true'                               │  │
│  │ ]                                                       │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## PDF Generation Pipeline

```
┌──────────────────────────────────────┐
│ _generateFarmReport()                │
│ (home_screen.dart)                   │
└──────────┬───────────────────────────┘
           │
           ├─ Read all required data:
           │  • thisMonthEggTotalProvider
           │  • thisMonthSalesTotalProvider
           │  • thisMonthExpensesTotalProvider
           │  • thisMonthProfitLossProvider
           │  • flockCountProvider
           │  • thisMonthFeedCostPerEggProvider
           │  • allDailyLogsProvider
           │  • allChickensProvider
           │  • reportSettingsProvider ◄──── NEW!
           │
           └─ Create FarmReportData with settings
                │
                ↓
┌──────────────────────────────────────┐
│ PdfExportService.generateFarmReportCard()
│ (pdf_export_service.dart)            │
├──────────────────────────────────────┤
│                                      │
│ _generateFarmReportCardImpl()         │
│   ↓                                  │
│ Create PDF Document                 │
│   ↓                                  │
│ Build Header (farm name, date)       │
│   ↓                                  │
│ _buildStatsGridWithSettings() ◄─── NEW!
│   │                                  │
│   ├─ For each ReportMetric:          │
│   │  if (data.settings.isEnabled)    │
│   │    add to stats list             │
│   │                                  │
│   └─ Layout: 4 metrics per row       │
│                                      │
│ Add Daily Production Chart           │
│   ↓                                  │
│ Add Footer                           │
│   ↓                                  │
│ Write PDF to file                    │
│                                      │
└────────────────────┬─────────────────┘
                     │
                     ↓
            Share PDF via Share Plus
```

## Architecture Diagram

```
┌────────────────────────────────────────────────────────────────┐
│                      HOME SCREEN                               │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Drawer Menu                                              │  │
│  │ ┌────────────────────────────────────────────────────┐   │  │
│  │ │ Farm Report Settings (NEW)  → route → /report...  │   │  │
│  │ │ Data Management                                   │   │  │
│  │ └────────────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Farm Report Button                                             │
│         │                                                       │
│         └─→ _generateFarmReport()                              │
│              │                                                  │
│              └─→ reportSettingsProvider (read)                 │
│                   │                                             │
│                   ↓                                             │
│         Create FarmReportData(settings=...)                    │
│                   │                                             │
│                   ↓                                             │
│         Generate PDF (conditional metrics)                     │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│                   REPORT SETTINGS SCREEN (NEW)                 │
│  Displays ReportSettingsScreen widget                          │
│         │                                                       │
│         └─→ reportSettingsProvider (watch & write)             │
│              │                                                  │
│              ├─→ ReportSettingsNotifier.setMetricEnabled()     │
│              │    │                                             │
│              │    └─→ SharedPreferences.setStringList()        │
│              │                                                  │
│              └─→ State updates reactively                      │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│            PDF EXPORT SERVICE (ENHANCED)                        │
│                                                                │
│  _buildStatsGridWithSettings(FarmReportData)                   │
│  ├─ If settings.totalEggs → add eggs metric                    │
│  ├─ If settings.totalSales → add sales metric                  │
│  ├─ If settings.totalExpenses → add expenses metric            │
│  ├─ If settings.profitLoss → add profit metric (colored)       │
│  ├─ If settings.flockCount → add flock metric                  │
│  ├─ If settings.layingCount → add laying metric                │
│  ├─ If settings.feedPerEgg → add feed/egg metric               │
│  ├─ If settings.layingPercentage → add lay % metric            │
│  └─ Layout: wrap at 4 metrics per row                          │
│                                                                │
│  Result: pw.Column with pw.Rows of pt.Widgets                 │
└────────────────────────────────────────────────────────────────┘
```

## Data Model Changes

```
BEFORE:
┌─────────────────────────┐
│   FarmReportData        │
├─────────────────────────┤
│ - farmName              │
│ - monthLabel            │
│ - totalEggs             │
│ - totalSales            │
│ - totalExpenses         │
│ - profitLoss            │
│ - flockCount            │
│ - layingCount           │
│ - feedPerEgg            │
│ - dailyEggs             │
└─────────────────────────┘

AFTER:
┌─────────────────────────────┐
│   FarmReportData (NEW)      │
├─────────────────────────────┤
│ - farmName                  │
│ - monthLabel                │
│ - totalEggs                 │
│ - totalSales                │
│ - totalExpenses             │
│ - profitLoss                │
│ - flockCount                │
│ - layingCount               │
│ - feedPerEgg                │
│ - dailyEggs                 │
│ - settings: ReportSettings  │ ◄───── NEW FIELD
└─────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│   ReportSettings (NEW)               │
├──────────────────────────────────────┤
│ - totalEggs: bool                    │
│ - totalSales: bool                   │
│ - totalExpenses: bool                │
│ - profitLoss: bool                   │
│ - flockCount: bool                   │
│ - layingCount: bool                  │
│ - feedPerEgg: bool                   │
│ - layingPercentage: bool             │
└──────────────────────────────────────┘
```

## File Organization

```
lib/
├── core/
│   ├── providers/
│   │   ├── farm_name_provider.dart (existing)
│   │   ├── database_providers.dart (existing)
│   │   └── report_settings_provider.dart ◄──── NEW!
│   │
│   └── services/
│       └── pdf_export_service.dart (modified)
│           ├── _buildStatsGridWithSettings() ◄──── NEW!
│           └── FarmReportData.settings ◄──── ADDED
│
└── features/
    └── home/
        └── screens/
            ├── home_screen.dart (modified)
            │   ├── _generateFarmReport() (updated)
            │   └── drawer menu (updated)
            │
            └── report_settings_screen.dart ◄──── NEW!
                └── ReportSettingsScreen widget

config/
└── router.dart (modified)
    ├── Routes.reportSettings ◄──── NEW!
    └── GoRoute(/report-settings) ◄──── NEW!
```

---

**Visual Guide Complete** ✅
Ready for implementation and deployment!


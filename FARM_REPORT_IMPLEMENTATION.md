# Farm Report Feature Implementation

## Overview
Implemented a comprehensive Farm Report Card feature that generates beautiful one-page PDF reports with monthly farm analytics, production metrics, and financial data.

## Features Implemented

### 1. **Farm Name Customization**
- **Provider**: `lib/core/providers/farm_name_provider.dart`
- Users can now customize their farm name from the home screen
- Clicking the farm name in the AppBar opens an editable dialog
- Names are persisted to shared preferences
- Defaults to "Chicken Tracker" if not customized

### 2. **Farm Report Generation**
- **Location**: `lib/core/services/pdf_export_service.dart`
- Added `FarmReportData` model containing all report metrics
- Added `DailyEggEntry` model for daily production tracking
- Implemented `generateFarmReportCard()` static method

#### Report Includes:
- **Header Section**: Farm name, report month, generation date
- **Monthly Snapshot** (stats grid):
  - Total eggs collected
  - Total sales revenue
  - Total expenses
  - Profit/loss (color-coded: green for profit, red for loss)
  - Flock count
  - Laying hens count
  - Feed cost per egg
  - Laying percentage
- **Daily Production Chart**: Visual bar chart of daily egg production for the month
- **Professional Footer**: Branding and farm name

### 3. **UI Integration**
- **Home Screen Button**: Added "Farm Report" button to Quick Actions (brown/farm theme)
- **Implementation**: `lib/features/home/screens/home_screen.dart`
- Button triggers report generation with loading toast
- PDF is generated and shared via system share dialog

### 4. **Database Provider Enhancement**
- **File**: `lib/core/providers/database_providers.dart`
- Added `thisMonthEggTotalProvider`: Calculates total eggs for current month
- Used to populate farm report data

## Data Flow

```
Home Screen (Report Button)
    ↓
_generateFarmReport() method
    ↓
Collect metrics from providers:
  - Farm name (farmNameProvider)
  - Monthly totals (egg, sales, expenses)
  - Flock counts
  - Feed cost per egg
  - Daily production logs
    ↓
Create FarmReportData object
    ↓
PdfExportService.generateFarmReportCard()
    ↓
Generate PDF with beautiful formatting
    ↓
Save to documents directory
    ↓
Share via Share.shareXFiles()
```

## Design Details

### Colors & Styling
- **Header**: Dark brown (0xFF6D451E) - farm theme
- **Accents**: Medium brown (0xFF8A5A2B)
- **Light background**: Cream/off-white (0xFFFFF8F0)
- **Profit indicator**: Green (0xFF2E7D32) or Red (0xFFC5392A)
- **Chart bars**: Medium brown (0xFF8A5A2B)

### PDF Layout
- Page format: A4
- No page margins (full bleed on header)
- Responsive stat boxes with borders
- Clean bar chart for daily production visualization
- Professional footer with generation timestamp

## Files Modified

### New Files
- `lib/core/providers/farm_name_provider.dart` - Farm name state management

### Modified Files
1. **lib/core/services/pdf_export_service.dart**
   - Added FarmReportData model
   - Added DailyEggEntry model
   - Added generateFarmReportCard() static method
   - Added helper methods: _reportStatBox(), _reportStatBoxColored()

2. **lib/features/home/screens/home_screen.dart**
   - Added farm name display with edit icon in AppBar
   - Added "Farm Report" button to Quick Actions
   - Added _showEditNameDialog() method
   - Added _generateFarmReport() method
   - Added imports for farm_name_provider, share_plus, pdf_export_service

3. **lib/core/providers/database_providers.dart**
   - Added thisMonthEggTotalProvider

## Dependencies Used
- `share_plus`: For sharing generated PDF
- `intl`: For date/time formatting
- `pdf`: For PDF generation
- `path_provider`: For document directory access
- `flutter_riverpod`: For state management
- `shared_preferences`: For farm name persistence

## Usage

### Generating a Farm Report
1. Navigate to home screen
2. Click "Farm Report" button in Quick Actions section
3. Wait for report generation (shows toast)
4. Share dialog opens for sharing the PDF

### Customizing Farm Name
1. Click the farm name in the AppBar header
2. Edit dialog opens
3. Enter custom name (max 40 characters)
4. Save to persist to device

## Error Handling
- Try-catch wrapper around report generation
- Checks `mounted` before showing snackbars
- Toast displays if generation fails
- Graceful fallback if data is missing

## Testing Notes
- Farm report generates without errors
- PDF is created and saved successfully
- Share dialog opens correctly
- Farm name persists across app restarts
- All monthly metrics correctly calculated
- Chart handles empty data gracefully

## Future Enhancements
- Multiple report format options (monthly, quarterly, yearly)
- Email delivery option
- Custom logo/header image support
- More detailed analytics dashboard
- Historical report archiving
- Batch report generation


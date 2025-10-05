# Shelter Donation Manager

A Flutter app to track donations for a local shelter, manage contributors, and distribute items to those in need. Supports money, food, and clothes donations, with partial distribution and reporting features.

---

## Features

- **Add Donations**: Track donations by contributor, type (Money, Food, Clothes), item name, and quantity/amount.  
- **Partial Distribution**: Distribute part or all of a donation while keeping track of remaining amounts.  
- **Dynamic Views**: Toggle between viewing donations by **Contributor** or **Type**.  
- **Reports Screen**:  
  - **Donations Tab**: Shows remaining donations with totals.  
  - **Distribution Tab**: Shows distributed items, partially distributed items color-coded.  
  - Sort by contributor or type.  
- **Totals Display**: Quickly see total money or total remaining items.  
- **Color-coded Interface**:  
  - 🟢 Green = Money  
  - 🟠 Orange = Food  
  - 🔵 Blue = Clothes  
  - 🔴 Red = Fully distributed items  

---

## Getting Started

**Clone the repository**

```bash``
   git clone https://github.com/mendelcrrll/shelter-donation-app.git
   cd shelter-donation-app```

**Install dependencies**

``` ``
   flutter pub get```


**Run the app**

``` ``
   flutter run```


You can target an Android/iOS emulator or Chrome web.

## How to Use

**Donation view**

-Add a Donation

-Enter the contributor's name.

-Select the donation type (Money, Food, Clothes).

-Enter the item name or amount.

-Enter quantity for Food or Clothes (optional for Money).

-Click Donate.

-View Donations

-Toggle View by Contributor or View by Type.

-Expansion tiles show individual donations for contributors or grouped by type.

**Distribution view**

-Click Go to Distribution to mark items as partially or fully distributed.

-Distribution reduces remaining quantity/amount in the donation list.

**Reports**

Click View Reports to see a dedicated screen for Donations and Distribution.

Tabs separate remaining donations from distributed items.

Items color-coded:

⚪ White = not distributed

🟠 Orange = partially distributed

🔴 Red = fully distributed

Sort donations by Contributor or Type from the popup menu.

## Dependencies

Flutter

Provider
 for state management

## Notes

All donations are timestamped with date and time.

Partial distributions update the remaining quantities automatically.

Designed for easy maintenance and extension.

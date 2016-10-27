# Weather
Weather is a simple app that shows how to retrieve weather data for a given location, by using `http://openweathermap.org/api`

Weather has been imlpemented using VIPER design pattern, this way we completely separate logic from different modules. Refer to `https://www.objc.io/issues/13-architecture/viper/` for more information about VIPER.

This simple app contains an API for the forecast service and 2 main VIPER modules:
- Forecast
- Searches

### Forecast
Forecast shows the weather for a desired region. If you didn't use the app before, there will be no weather information, so you can go to "Search Location" and select the desired one.
If you already used the app, then it will retrieve your last search as soon as you open it. I have decided to request this information again, instead of using `NSCoder` and remember the latest data, because it makes more sense for this type of app, where the data changes constantly and you need an updated information.

### Searches
This module contains a table view with two sections. The first section shows your latest searches, and allows you to remove any of the searches by swaping the cell from right to left. Alternatively, you can also press on `edit` and remove your searches or clear all the history by pressing on `Clear History`.

### History
History class manages your searches by adding/removing them on user defaults. There is no limit on your searches, but we could limit the size of the array if needed.
History allows to retrieve either the last search or all the searches, remove a desired search or clear everything.

### 3rd Parties
We use `Cocoapods` in order to import external libraries. We have imported two libraries for this demo app:
- *SDWebImage:* It's a really useful library for async image download
- *MBProgressHUD:* Simple library for activity indicator.
If you need to add/remove/update any of the libraries, you just need to modify the `Podfile` file and run the following command:

```sh
$ pod install
```

### App Icons and design
I have setup assets catalogues for the icons of both targets. This way we can customize the icons for each country. However, I haven't designed any icon. In case we need to set the assets we just need to add them to the specific catalogue.

Since there wasn't any request on designs, I haven't focused on the design, so the app simply shows few labels and other objects with no design or style guide (other that iOS style guide).

However, there was a design request, which was to have an specific schemme color for each country, so what I've done is to set a different tint color (refer to `AppDelegate` to see the code) for each country.

### Unit Tests
I have added Unit Tests for the most critical classes of the app, such us the network API and History class. However, since I have used VIPER for the screens implementations, it would be really easy to test each individual submodule of VIPER modules in order to test all the logic of the app.

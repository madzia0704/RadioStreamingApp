# 📻 Polish Streaming iOS App

Aplikacja do słuchania polskiego radia. Umożliwia wyszukiwanie stacji, odtwarzanie na żywo i dodawanie stacji do ulubionych.

## ▶️ Jak uruchomić?

1. Sklonuj repozytorium:
```bash
git clone https://github.com/madzia0704/RadioStreamingApp

2. Otwórz .xcodeproj lub .xcworkspace

3. Uruchom na symulatorze lub urządzeniu z iOS 15+

🧪 Testy
Uruchom testy z poziomu Xcode (Cmd + U)

------------------

1. Architektura: MVVM + Combine
2. Technologie

Swift 5.9+ (SwiftUI -> jest lepiej zintegrowany z Combine. Nowocześniejszy niż UIKit i rekomendowany do nowych aplikacji)
iOS 15.0+
MVVM + Combine
Networking: URLSession
Audio: AVPlayer (preferowany do streamingu)
Powiadomienia: UNUserNotificationCenter
Testy: XCTest

3. Funkcjonalności
EKRAN 1: (StationListView)
🔍 Wyszukiwarka i lista stacji
-> Wyświetla listę stacji
-> Filtrowanie i wyszukiwanie: przez Combine w StationListViewModel (Stworzyłam jeden ekran, na którym są wyświetlane i filtrowane stacje. Uznałam, że tak będzie przyjaźniej dla użytkownika i bardziej intuicyjnie. Dlatego zamiast dwóch kontrolerów StationListViewController i SearchViewController, mamy jeden StationListViewModel).
Użytkownik może filtrować stacje po nazwie i mieście (można podać część nazwy) oraz po kategorii (wybór kategorii poprzez kliknęcie na odpowiednią zakładkę / tab).
-> Zawiera przełącznik "Użyj Api" - wyświetla realne dane (true) lub zamockowane (false). Api nie zawiera wszystkich wymaganych danych, dlatego zdecydowałam się na dodanie opcji wyświetlenia zamockowanych danych.
-> Użytkownik może zaznaczyć stację jako ulubioną.
-> Po kliknięciu na daną stację przechodzi do ekranu odtwarzania

EKRAN 2: (FavoritesView)
Ulubione
FavoritesViewModel (zamiast FavoritesViewController )
-> Wyświetla listę ulubionych stacji
-> Ulubione: zapis lokalny z UserDefaults
-> Po kliknięciu na daną stację przechodzi do ekranu odtwarzania

🔔 Powiadomienia
UNUserNotificationCenter do wysyłania lokalnych powiadomień o dodaniu lub usunięciu stacji z ulubionych

EKRAN 3:(PlayerView)
🎧 Odtwarzacz audio
Odtwarzacz audio (AVPlayer) - możliwość odtwarzania wybranej stacji ( play / pause)
-> odtwarzanie w tle (jeśli zminimalizujemy aplikację)
-> odtwarzanie jest przerywane po wyjściu z ekranu
-> obsługa Lock Screen (MPNowPlayingInfoCenter + Remote Command Center)


6. Serwisy
📡 RadioStationFetcher
Pobieranie danych stacji z API lub lokalnego pliku JSON (na potrzeby demo)

🎶 RadioPlayerManager
Zarządzanie AVPlayer, Lock Screen Info, obsługa Remote Control

🧠 FavoritesManager
Zarządzanie ulubionymi stacjami (UserDefaults)

🔔 NotificationManager
Tworzenie i obsługa lokalnych powiadomień

✅ 7. Testy jednostkowe (XCTest)
✅ testSearchStationByName() – sprawdza wyszukiwanie po nazwie
✅ testFilterStationsByCategory() – test filtrowania po kategorii
✅ testFavoriteToggle() – test dodawania do ulubionych
✅ RadioPlayerManagerTests – testy inicjalizacji i działania AVPlayer
✅ testNotifyFavoriteSchedulesNotification() – test generowania powiadomień lokalnych


AUTOR: Magdalena Popińska

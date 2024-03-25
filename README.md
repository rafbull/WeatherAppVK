## Приложение прогноза погоды **"WeatherAppVK"**

- Приложение сделано на **UIKit** по архитектуре **MVVM + C** с использованием **Combine**. 
- В приложении есть прогноз с **3-х часовым** интервалом на ближайшие два дня, и прогноз на **5 дней**.
- Есть **удобный поиск** по городам.
- Осуществлено **кеширование данных**. В случае **отстутствия интернета**, пользователю будет показан прогноз **последней просмотренной** локации.
- Если кешированные данные отсутствуют, пользователь увидит соответствующее сообщение.


---

#### Использованный стек:

- UIKit
- Auto Layout
- MVVM
- Coordinator
- Combine
- MapKit
- CoreLocation
- DiffableDataSource
- Min iOS - 15.0

---

## Скриншоты

### Основной интерфейс


| ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 22 33 01](https://github.com/rafbull/WeatherAppVK/assets/148709354/abd0701a-4d1c-410a-93d1-531c3dda0c6c) | ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 22 33 11](https://github.com/rafbull/WeatherAppVK/assets/148709354/a1d14745-0e2f-4c90-a1fd-c70aad28ddb2) |
| --- | --- |

---

### Запрос геолокации и экран поиска


| ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 22 31 38](https://github.com/rafbull/WeatherAppVK/assets/148709354/2b54b59d-9bd9-4a64-b896-8cf2b0f5b4b0) | ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 23 03 57](https://github.com/rafbull/WeatherAppVK/assets/148709354/72b2d50c-0b5c-4d14-852f-1452846424ac) |
| --- | --- |

---

### Сообщение об отсутсвии интернет соединения и экран при пустом кэше


| ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 22 41 29](https://github.com/rafbull/WeatherAppVK/assets/148709354/5a1fc8e1-6d11-4274-86aa-d84d2531586c) | ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 22 41 39](https://github.com/rafbull/WeatherAppVK/assets/148709354/4df9124b-28ad-4da5-8926-7a8c33aa84e6) |
| --- | --- |

---

### Сообщение об отсутсвии интернет соединения и экран при наличии кэша


| ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 22 53 43](https://github.com/rafbull/WeatherAppVK/assets/148709354/fdb25aad-3b93-43bf-b216-68c407705613) | ![Simulator Screen Shot - iPhone 13 Pro - 2024-03-25 at 23 13 42](https://github.com/rafbull/WeatherAppVK/assets/148709354/2bf53663-cb5e-42a8-a460-78651253d31b) |
| --- | --- |

---

## Дизайн

Автор оригинального дизайна [Saeedworks](https://dribbble.com/saeedworks)

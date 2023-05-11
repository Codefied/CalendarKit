import UIKit
import CalendarKit

final class CustomCalendarExampleController: DayViewController {
  var data = [["Breakfast at Tiffany's",
               "New York, 5th avenue"],
              
              ["Workout",
               "Tufteparken"],
              
              ["Meeting with Alex",
               "Home",
               "Oslo, Tjuvholmen"],
              
              ["Beach Volleyball",
               "Ipanema Beach",
               "Rio De Janeiro"],
              
              ["WWDC",
               "Moscone West Convention Center",
               "747 Howard St"],
              
              ["Google I/O",
               "Shoreline Amphitheatre",
               "One Amphitheatre Parkway"],
              
              ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
               "Oslo Gardermoen"],
              
              ["💻📲 Developing CalendarKit",
               "🌍 Worldwide"],
              
              ["Software Development Lecture",
               "Mikpoli MB310",
               "Craig Federighi"],
              
  ]
  
  var generatedEvents = [EventDescriptor]()
  var alreadyGeneratedSet = Set<Date>()
  
  var colors = [UIColor.blue,
                UIColor.yellow,
                UIColor.green,
                UIColor.red]
  
  private lazy var dateIntervalFormatter: DateIntervalFormatter = {
    let dateIntervalFormatter = DateIntervalFormatter()
    dateIntervalFormatter.dateStyle = .none
    dateIntervalFormatter.timeStyle = .short
    
    return dateIntervalFormatter
  }()
  
  override func loadView() {
    calendar.timeZone = TimeZone(identifier: "Europe/Paris")!
    
    dayView = DayView(calendar: calendar)
    view = dayView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CalendarKit Demo"
    navigationController?.navigationBar.isTranslucent = false
    dayView.autoScrollToFirstEvent = true
    reloadData()
  }
  
  // MARK: EventDataSource
  
  override func eventsForDate(_ date: Date) -> [EventDescriptor] {
      var events = [Event]()

      events.append(event(startHour: 8, endHour: 16, name: "1"))
      events.append(event(startHour: 8, startMinute: 30, endHour: 11, name: "2"))
      events.append(event(startHour: 9, endHour: 10, name: "3"))
      events.append(event(startHour: 10, endHour: 11, name: "4"))
      events.append(event(startHour: 9, startMinute: 30, endHour: 10, endMinute: 30, name: "5"))
      events.append(event(startHour: 10, startMinute: 30, endHour: 11, endMinute: 30, name: "6"))
      events.append(event(startHour: 11, endHour: 12, name: "7"))
      events.append(event(startHour: 12, endHour: 13, name: "8"))
      events.append(event(startHour: 12, endHour: 13, name: "9"))
      events.append(event(startHour: 12, startMinute: 30, endHour: 13, endMinute: 30, name: "10"))
      events.append(event(startHour: 13, endHour: 14, name: "11"))
      events.append(event(startHour: 13, endHour: 14, name: "12"))
      events.append(event(startHour: 14, endHour: 15, name: "13"))
      events.append(event(startHour: 14, endHour: 15, name: "14"))
      events.append(event(startHour: 15, endHour: 16, name: "15"))
      events.append(event(startHour: 15, endHour: 16, name: "16"))

      events.append(event(startHour: 10, endHour: 11, name: "17"))
      events.append(event(startHour: 15, endHour: 16, name: "18"))
      events.append(event(startHour: 12, endHour: 13, name: "19"))
      events.append(event(startHour: 13, endHour: 14, name: "20"))
      return events
    }

    private func event(startHour: Int, startMinute: Int = 0, endHour: Int, endMinute: Int = 0, name: String) -> Event {
      let event = Event()
      let startDate = makeDate(hour: startHour, minute: startMinute)
      let endDate = makeDate(hour: endHour, minute: endMinute)
      event.dateInterval = DateInterval(start: startDate, end: endDate)
      event.text = name
      return event
    }

    private func makeDate(hour: Int, minute: Int) -> Date {

      let calendar = Calendar.current

      let currentDateComponents = calendar.dateComponents(Set([.day, .month, .year]), from: Date())
      var components = DateComponents()

      if let day = currentDateComponents.day,
         let month = currentDateComponents.month,
         let year = currentDateComponents.year {
        components.day = day
        components.month = month
        components.year = year
        components.hour = hour
        components.minute = minute
      }

      return Calendar.current.date(from: components)!
    }
  
  // MARK: DayViewDelegate
  
  private var createdEvent: EventDescriptor?
  
  override func dayViewDidSelectEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
  }
  
  override func dayViewDidLongPressEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? Event else {
      return
    }
    endEventEditing()
    print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    beginEditing(event: descriptor, animated: true)
    print(Date())
  }
  
  override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
    endEventEditing()
    print("Did Tap at date: \(date)")
  }
  
  override func dayViewDidBeginDragging(dayView: DayView) {
    endEventEditing()
    print("DayView did begin dragging")
  }
  
  override func dayView(dayView: DayView, willMoveTo date: Date) {
    print("DayView = \(dayView) will move to: \(date)")
  }
  
  override func dayView(dayView: DayView, didMoveTo date: Date) {
    print("DayView = \(dayView) did move to: \(date)")
  }
  
  override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
    print("Did long press timeline at date \(date)")
    // Cancel editing current event and start creating a new one
    endEventEditing()
    let event = generateEventNearDate(date)
    print("Creating a new event")
    create(event: event, animated: true)
    createdEvent = event
  }
  
  private func generateEventNearDate(_ date: Date) -> EventDescriptor {
    let duration = (60...220).randomElement()!
    let startDate = Calendar.current.date(byAdding: .minute, value: -Int(Double(duration) / 2), to: date)!
    let event = Event()
    
    event.dateInterval = DateInterval(start: startDate, duration: TimeInterval(duration * 60))
    
    var info = data.randomElement()!
    
    info.append(dateIntervalFormatter.string(from: event.dateInterval)!)
    event.text = info.reduce("", {$0 + $1 + "\n"})
    event.color = colors.randomElement()!
    event.editedEvent = event
    
    return event
  }
  
  override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    print("did finish editing \(event)")
    print("new startDate: \(event.dateInterval.start) new endDate: \(event.dateInterval.end)")
    
    if let _ = event.editedEvent {
      event.commitEditing()
    }
    
    if let createdEvent = createdEvent {
      createdEvent.editedEvent = nil
      generatedEvents.append(createdEvent)
      self.createdEvent = nil
      endEventEditing()
    }
    
    reloadData()
  }
}

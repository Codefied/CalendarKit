import UIKit
import CalendarKit
import DateToolsSwift

class CustomCalendarExampleController: DayViewController, DatePickerControllerDelegate {
  
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
  
  var currentStyle = SelectedStyle.Light
  
  lazy var customCalendar: Calendar = {
    let customNSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    customNSCalendar.timeZone = TimeZone(abbreviation: "CEST")!
    let calendar = customNSCalendar as Calendar
    return calendar
  }()
  
  override func loadView() {
    calendar = customCalendar
    dayView = DayView(calendar: calendar)
    view = dayView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "CalendarKit Demo"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dark",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(ExampleController.changeStyle))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Change Date",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(ExampleController.presentDatePicker))
    navigationController?.navigationBar.isTranslucent = false
    dayView.autoScrollToFirstEvent = true
    reloadData()
  }
  
  @objc func changeStyle() {
    var title: String!
    var style: CalendarStyle!
    
    if currentStyle == .Dark {
      currentStyle = .Light
      title = "Dark"
      style = StyleGenerator.defaultStyle()
    } else {
      title = "Light"
      style = StyleGenerator.darkStyle()
      currentStyle = .Dark
    }
    updateStyle(style)
    navigationItem.rightBarButtonItem!.title = title
    navigationController?.navigationBar.barTintColor = style.header.backgroundColor
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:style.header.swipeLabel.textColor]
    reloadData()
  }
  
  @objc func presentDatePicker() {
    let picker = DatePickerController()
    //    let calendar = dayView.calendar
    //    picker.calendar = calendar
    //    picker.date = dayView.state!.selectedDate
    picker.datePicker.timeZone = TimeZone(secondsFromGMT: 0)!
    picker.delegate = self
    let navC = UINavigationController(rootViewController: picker)
    navigationController?.present(navC, animated: true, completion: nil)
  }
  
  func datePicker(controller: DatePickerController, didSelect date: Date?) {
    if let date = date {
      var utcCalendar = Calendar(identifier: .gregorian)
      utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
      
      let offsetDate = dateOnly(date: date, calendar: dayView.calendar)
      
      print(offsetDate)
      dayView.state?.move(to: offsetDate)
    }
    controller.dismiss(animated: true, completion: nil)
  }
  
  func dateOnly(date: Date, calendar: Calendar) -> Date {
    let yearComponent = calendar.component(.year, from: date)
    let monthComponent = calendar.component(.month, from: date)
    let dayComponent = calendar.component(.day, from: date)
    let zone = calendar.timeZone
    
    let newComponents = DateComponents(timeZone: zone,
                                       year: yearComponent,
                                       month: monthComponent,
                                       day: dayComponent)
    let returnValue = calendar.date(from: newComponents)
    
    //    let returnValue = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)
    
    
    return returnValue!
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
    event.startDate = makeDate(hour: startHour, minute: startMinute)
    event.endDate = makeDate(hour: endHour, minute: endMinute)
    event.text = name
    return event
  }
  
  private func makeDate(hour: Int, minute: Int) -> Date {
    var components = DateComponents()
    components.day = 19
    components.month = 6
    components.year = 2020
    components.hour = hour - 9
    components.minute = minute
    
    return Calendar.current.date(from: components)!
  }
  
  private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
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
    let duration = Int(arc4random_uniform(160) + 60)
    let startDate = date.subtract(TimeChunk.dateComponents(minutes: Int(CGFloat(duration) / 2)))
    let event = Event()
    let datePeriod = TimePeriod(beginning: startDate,
                                chunk: TimeChunk.dateComponents(minutes: duration))
    event.startDate = datePeriod.beginning!
    event.endDate = datePeriod.end!
    
    var info = data[Int(arc4random_uniform(UInt32(data.count)))]
    let timezone = dayView.calendar.timeZone
    info.append(datePeriod.beginning!.format(with: "dd.MM.YYYY", timeZone: timezone))
    info.append("\(datePeriod.beginning!.format(with: "HH:mm", timeZone: timezone)) - \(datePeriod.end!.format(with: "HH:mm", timeZone: timezone))")
    event.text = info.reduce("", {$0 + $1 + "\n"})
    event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
    event.editedEvent = event
    
    // Event styles are updated independently from CalendarStyle
    // hence the need to specify exact colors in case of Dark style
    if currentStyle == .Dark {
      event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
      event.backgroundColor = event.color.withAlphaComponent(0.6)
    }
    return event
  }
  
  override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    print("did finish editing \(event)")
    print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
    
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

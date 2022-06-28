import UIKit
import Photos
import UserNotifications

class MealsInputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
  //Var to CoreDate
  var imageCoreData: NSData?
  var namaCoreData: String?
  var kategoriCoreData: [String] = []
  var timeStampCoreData: Date?
  var preGulaCoreData: Int64?
  
  // Temp Var
  var strDate: String?
  var strTime: String?
  var strDateTime: String?
  
  //COBA POST
  var foodlist: [Food] = []
  
//  @IBAction func unwindToMealsInput(_ unwindSegue: UIStoryboardSegue) {
//    if unwindSegue.identifier == "mealsInputUnwind"{
//      let sourceViewController = unwindSegue.source as! CategoryViewController
//      kategoriCoreData = sourceViewController.categoryString
//      print(kategoriCoreData)
//    }
//    // Use data from the view controller which initiated the unwind segue
//  }
  
//  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var cameraPreview: UIImageView!
  @IBOutlet weak var foodUI: UIView!
  @IBOutlet weak var DateTime: UIView!
  @IBOutlet weak var FoodName: UIView!
  @IBOutlet weak var Category: UIView!
  @IBOutlet weak var DateView: UIView!
  @IBOutlet weak var TimeView: UIView!
  @IBOutlet weak var preGlucoseView: UIView!

  
  @IBOutlet weak var preGlucoseTextField: UITextField!
  @IBOutlet weak var foodTextField: UITextField!
  @IBOutlet weak var CategoryButton: UIButton!
  @IBOutlet weak var DatePicker: UIDatePicker!
  @IBOutlet weak var TimePicker: UIDatePicker!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  @IBAction func tapFrame(_ sender: UITapGestureRecognizer) {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  var imagePickerController = UIImagePickerController()
  var picker = UIImagePickerController()
  
  override func viewDidLoad() {
  super.viewDidLoad()

    roundUIView()
    imagePickerController.delegate = self
    cameraPreview.layer.cornerRadius = 8
    cameraPreview.clipsToBounds = true
    cameraPreview.layer.borderWidth = 1
    cameraPreview.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
    cameraPreview.contentMode = .scaleAspectFit
    
    //Check All Permission
    checkPermission()
    
    //To Get Rid of the Keyboard
    foodTextField.returnKeyType = .done
    preGlucoseTextField.returnKeyType = .done
    
    foodTextField.delegate = self
    preGlucoseTextField.delegate = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
    registerLocal()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "mealsToCategory" {
      let destination = segue.destination as! CategoryViewController
      destination.delegate = self
    }
  }
//MARK: - Rounding the View
  private func roundUIView(){
    DateTime.layer.cornerRadius = 8
    DateView.layer.cornerRadius = 5
    TimeView.layer.cornerRadius = 5
  }
  
//MARK: - Get Date Data
  
  func getDate(DatePicker: Date){
    let dateFormatr = DateFormatter()
    dateFormatr.dateFormat = "yyyy/MM/dd"
    strDate = dateFormatr.string(from: (DatePicker))
  }
  func getTime(TimePicker: Date){
    let dateFormatr2 = DateFormatter()
    dateFormatr2.dateFormat = "HH:mm"
    strTime = dateFormatr2.string(from: (TimePicker))
  }

//MARK: - To Save
  @IBAction func saveAll(_ sender: Any) {
    //To Gate Date and Time
    getDate(DatePicker: DatePicker.date)
    getTime(TimePicker: TimePicker.date)
    //To Combine the String
    strDateTime = strDate!+" "+strTime!
    
    print(strDateTime!)
    
    //To Change the Format into Date Again
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    
    let date = dateFormatter.date(from:strDateTime!)
    let date2 = date ?? Date()
    
    
    timeStampCoreData = date2
    
    //Get Food dan input preGula
    namaCoreData = foodTextField.text!
    preGulaCoreData =  Int64(preGlucoseTextField.text!)!
    
    let image = cameraPreview.image
    let imageData = image?.jpegData(compressionQuality: 0.5) as? NSData

    
    //
//    kategoriCoreData = SharedInfo.shared.category
    //to Core Data
    DBHelper.shared.createFood(timestamp: timeStampCoreData!, nama: namaCoreData!, category: kategoriCoreData, image: imageData!, preGula: preGulaCoreData!)
    
//
//    foodlist = DBHelper.shared.getAllFood()
//    print(foodlist[foodlist.count-1].category as Any)
//    DBHelper.shared.editFood(postGula: preGula, timestamp: foodlist[foodlist.count-1].timestamp)
    reminderLocal()
    
    let saveButtonAlert = UIAlertController(
      title: "Good job",
      message: "Meals data added!",
      preferredStyle: .alert)

    let saveAlertAction = UIAlertAction(
      title: "Done",
      style: .default,
      handler: {_ in self.performSegue(withIdentifier: "unwindToMeals", sender: self)})
    saveButtonAlert.addAction(saveAlertAction)
    present(saveButtonAlert, animated: true, completion: nil)
    
  }
  
  
  //MARK: - ToCategory
  
  @IBAction func tappedCategoryButton(_ sender: Any) {
    performSegue(withIdentifier: "mealsToCategory", sender: sender)
  }
  
  
  //MARK: - Image Input
  
//  @IBAction func tappedCameraButton(_ sender: Any) {
//    let picker = UIImagePickerController()
//    picker.sourceType = .camera
//    picker.allowsEditing = true
//    picker.delegate = self
//    present(picker, animated: true)

//    let defaultAction = UIAlertAction(title: "Camera",
//                                      style: .default) { [self] (action) in
//   // Respond to user selection of the action.
//              let picker = UIImagePickerController()
//              picker.sourceType = .camera
//              picker.allowsEditing = true
//              picker.delegate = self
//              self.present(picker, animated:true)
//

//    }
//    let cancelAction = UIAlertAction(title: "Gallery",
//                         style: .cancel) { (action) in
//      self.imagePickerController.sourceType = .photoLibrary
//      self.present(self.imagePickerController, animated: true, completion: nil)
//    }
//
//    // Create and configure the alert controller.
//    let alert = UIAlertController(title: "Method of Input",
//          message: "Please Choose the methode to take the photo",
//          preferredStyle: .alert)
//    alert.addAction(defaultAction)
//    alert.addAction(cancelAction)
//
//    self.present(alert, animated: true) {
//    }
//  }
    
  //MARK: - Check All Permission
  func checkPermission(){
    if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
      PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) -> Void in ()
      })
    }
    if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
    } else{
      PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
    }
  }
  
  func requestAuthorizationHandler(status: PHAuthorizationStatus){
    if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
      print("Access granted to use Photo Library")
    } else{
      print("We don't have access to your Photos.")
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
    if picker.sourceType == .photoLibrary{
      cameraPreview?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      let camera = info[UIImagePickerController.InfoKey.originalImage] as? NSData
      //to tem
      imageCoreData = camera!
    }
    else{
        let rawimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let resizedImage = rawimage?.resized(to: CGSize(width: 358, height: 195))
//      cameraPreview?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
      
        cameraPreview.image = resizedImage
//      let imageData:NSData = cameraPreview?.image!.jpegData(compressionQuality: 0.5)! as NSData
//      let camera = info[UIImagePickerController.InfoKey.originalImage] as? NSData
//      //to tem
//      imageCoreData = camera!
    }
    
    picker.dismiss(animated: true, completion:nil)
    
  }
  
  // FOR DATA INPUT (Probably important if Date and Time method above is not working
  
  // Date
//  func createDatePicker(){
//
//    inputDate.textAlignment = .center
//    //toolbar
//    let toolbar = UIToolbar()
//    toolbar.sizeToFit()
//
//    //barbutton
//    let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//    toolbar.setItems([doneBtn], animated: true)
//
//    //assign toolbar
//    inputDate.inputAccessoryView = toolbar
//
//    //assign date picker to the text field
//    inputDate.inputView = datePicker
//
//    datePicker.datePickerMode = .date
//
//  }
//
//  @objc func donePressed(){
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .none
//
//    inputDate.text = formatter.string(from: datePicker.date)
//    self.view.endEditing(true)
//  }
//
//
//  //Time
//  @objc func timePickerValueChanged(sender: UIDatePicker){
//    let formatter = DateFormatter()
//    formatter.locale = Locale(identifier: "en_gb")
//    formatter.dateFormat = "hh:mm"
//    inputTime.text = formatter.string(from: sender.date)
//  }
  
  
  // Private Function
  

  
  
  
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension MealsInputViewController: UITextFieldDelegate{
  func textFieldShouldReturn(_ foodTextField: UITextField) -> Bool {
    foodTextField.resignFirstResponder()
    return true
  }
}

extension MealsInputViewController: FoodCategoryDelegate {
  func saveData(category: [String]) {
          kategoriCoreData = category
//          print(kategoriCoreData)
  }
}

extension MealsInputViewController: UNUserNotificationCenterDelegate {
  func registerLocal() {
          let center = UNUserNotificationCenter.current()

          center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
              if granted {
                 print("Yay!")
              } else {
                  print("D'oh!")
              }
          }

      }
  
  func reminderLocal() {
          registerCategories()

          let center = UNUserNotificationCenter.current()
          center.removeAllPendingNotificationRequests()

          let content = UNMutableNotificationContent()
          content.title = "Post-Glucose"
          content.body = "Please input your post-meal glucose"
          content.categoryIdentifier = "alarm"
          content.userInfo = ["customData": "fizzbuzz"]
          content.sound = .default

          let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

          let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
          center.add(request)
  }
  
  func scheduleLocal() {
          registerCategories()

          let center = UNUserNotificationCenter.current()
          center.removeAllPendingNotificationRequests()

          let content = UNMutableNotificationContent()
          content.title = "Post-Glucose"
          content.body = "Please input your post-meal glucose"
          content.categoryIdentifier = "alarm"
          content.userInfo = ["customData": "fizzbuzz"]
          content.sound = .default

      //ini buat set kapan notifnya muncul -> ini muncul tiap jam 10 malam
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = 22
            dateComponents.minute = 00

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
  }
  
  func registerCategories() {
      let center = UNUserNotificationCenter.current()
      center.delegate = self

      let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
      let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

      center.setNotificationCategories([category])
  }

//  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler:
//                              @escaping() -> Void) {
//
////    let storyboard = UIStoryboard(name: "EditMeals", bundle: nil) //change to edit food with custom data
//
//    //initiate the view controller from storyboard
////    let editNavController = storyboard.instantiateViewController(withIdentifier: "EditMealsNavigationController") as! UINavigationController
////    let editFoodVC = editNavController.topViewController as! EditMealsViewController
//////        foodlist = DBHelper.shared.getAllFood()
////    editFoodVC.foodDetailSegue = DBHelper.shared.getTimeFood(timeStampCoreData ?? Date())
////    self.present(editNavController, animated: true)
//
////      let userInfo = response.notification.request.content.userInfo
//      // Print message ID
//      let userInfo = response.notification.request.content.userInfo
//
//      if let customData = userInfo["customData"] as? String {
//
//          print("Custom data received: \(customData)") //MASUKIN DATE TIME NYA DISINI
//
//          switch response.actionIdentifier {
//          case UNNotificationDefaultActionIdentifier:
//              //buat user swipe pas unlock
//                  print("Default identifier")
//
//          case "show" :
//              print("Show more information...")
//
//          default:
//              break
//          }
//      }
//
//      completionHandler()
//  }
//
}


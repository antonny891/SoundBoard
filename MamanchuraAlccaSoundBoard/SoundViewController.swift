//
//  SoundViewController.swift
//  MamanchuraAlccaSoundBoard
//
//  Created by Antonny Mmamanchura Alcca on 9/10/24.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirButton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            //detener la grabacion
            grabarAudio?.stop()
            //cambiar texto del boton grabar
            grabarButton.setTitle( "GRABAR", for: .normal)
        }else{
            //empezar a grabar
            grabarAudio?.record ()
            //cambiar el texto del boton grabar a detenerz
            grabarButton.setTitle("DETENER", for: .normal)
        }
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print ("Reproduciendo" )
        }catch {}
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            //detener la grabacion
            grabarAudio?.stop ()
            //cambiar texto del boton grabar
            grabarButton.setTitle ("GRABAR", for: .normal)
            reproducirButton.isEnabled = true
        }else{
            //empezar a grabar
            grabarAudio?.record ()
            //cambiar el texto del boton grabar a detener
            grabarButton.setTitle ("DETENER", for: .normal)
            reproducirButton.isEnabled = false
        }
    }
    
    func configurarGrabacion(){
        do{
            //creando sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default,
                options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            //creando direccion para el archivo de audio
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,
                                                                      true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            //impresion de ruta donde se guardan los archivos
            print("*********************")
            print (audioURL!)
            print("***********************")
            //crear opciones para el grabador de audio
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            //crear el objeto de grabacion de audio
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        }catch let error as NSError{
            print (error)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirButton.isEnabled  = false
        // Do any additional setup after loading the view.
    }
}

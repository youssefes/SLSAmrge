//
//  CameraController.swift
//  AV Foundation
//
//  Created by youssef on 2/10/21.
//  Copyright © 2021 Pranjal Satija. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraController : NSObject {
    
    
    let videoFileOutput : AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    var duration : Int = 30
    var v_path : URL = URL(fileURLWithPath: "")
    var my_timer : Timer = Timer()
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var flashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    

    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    func switchCameras() throws {
        //5
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        //6
        captureSession.beginConfiguration()
        
        //7
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        
        //8
        captureSession.commitConfiguration()
        
    }
    
    
    func switchToFrontCamera() throws {
        guard let captureSession = captureSession else {
            return
        }
        guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
            let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
        
        self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        
        captureSession.removeInput(rearCameraInput)
        
        if captureSession.canAddInput(self.frontCameraInput!) {
            captureSession.addInput(self.frontCameraInput!)
            
            self.currentCameraPosition = .front
        }
            
        else { throw CameraControllerError.invalidOperation }
    }
    
    func switchToRearCamera() throws {
        guard let captureSession = captureSession else {
            return
        }
        guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
            let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
        
        self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
        
        captureSession.removeInput(frontCameraInput)
        
        if captureSession.canAddInput(self.rearCameraInput!) {
            captureSession.addInput(self.rearCameraInput!)
            
            self.currentCameraPosition = .rear
        }
            
        else { throw CameraControllerError.invalidOperation }
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}

extension CameraController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        
        func createCaptureSession() {
            captureSession = AVCaptureSession()
        }
        
        
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = (session.devices.compactMap{ $0 })
            guard !cameras.isEmpty else {
                throw CameraControllerError.noCamerasAvailable }
            for camera in cameras {
                if camera.position == .front {
                    frontCamera = camera
                }
                
                if camera.position == .back {
                    rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            //3
            guard let captureSession = captureSession else {
                throw CameraControllerError.captureSessionIsMissing
                
            }
            
            //4
            if let rearCamera = rearCamera {
                rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(rearCameraInput!) { captureSession.addInput(rearCameraInput!) }
                
                currentCameraPosition = .rear
            }
                
            else if let frontCamera = frontCamera {
                frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(frontCameraInput!) { captureSession.addInput(frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                currentCameraPosition = .front
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        func configurePhotoOutput() throws {
            
            guard let captureSession = captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
            
            if captureSession.canAddOutput(photoOutput!) {
                captureSession.addOutput(photoOutput!)
                
            }
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
        
    }
    
    func stopCaptchVideo(){
        captureSession?.stopRunning()
        if let inputs = captureSession?.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession?.removeInput(input)
            }
        }
    }
    
    
    func returnedOrientation() -> AVCaptureVideoOrientation
    {
        var videoOrientation: AVCaptureVideoOrientation!
        let orientation = UIDevice.current.orientation
        switch orientation
        {
        case .landscapeLeft:
            videoOrientation = .landscapeRight
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        default:
            videoOrientation = .landscapeLeft
        }
        return videoOrientation
    }
    func takeVideoAction()
    {
        videoFileOutput.movieFragmentInterval = CMTime.invalid
        captureSession?.addOutput(videoFileOutput)
        (videoFileOutput.connections.first!).videoOrientation = returnedOrientation()
        videoFileOutput.startRecording(to: v_path, recordingDelegate: self)
    }
    
    func stopVideoAction()
    {
        videoFileOutput.stopRecording()
        captureSession?.stopRunning()
        // turn temp_video into an .mpeg4 (mp4) video
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let avAsset = AVURLAsset(url: v_path, options: nil)
        // there are other presets than AVAssetExportPresetPassthrough
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)!
        exportSession.outputURL = directory.appendingPathComponent("main_video.mp4")
        // now it is actually in an mpeg4 container
        exportSession.outputFileType = AVFileType.mp4
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
        exportSession.exportAsynchronously(completionHandler: {
            if (exportSession.status == AVAssetExportSession.Status.completed)
            {
                // you don’t need temp video after exporting main_video
                do
                {
                    try FileManager.default.removeItem(atPath: self.v_path.path)
                }
                catch
                {
                }
                // v_path is now points to mp4 main_video
                self.v_path = directory.appendingPathComponent("main_video.mp4")
            }
        })
    }
    
}

extension CameraController{
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}

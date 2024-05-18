//
//  ContentView.swift
//  Instafilter
//
//  Created by Martin Ivanov on 5/16/24.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit

enum CIParameters: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case radius = "Radius"
    case intensity = "Intensity"
    case scale = "Scale"
    
    var kCIInputKey: String {
        switch self {
        case .radius:
            return kCIInputRadiusKey
        case .intensity:
            return kCIInputIntensityKey
        case .scale:
            return kCIInputScaleKey
        }
    }
    
    var valueMultiplier: Double {
        switch self {
        case .radius:
            return 200.0
        case .intensity:
            return 1.0
        case .scale:
            return 10.0
        }
    }
}

enum SupportedFilters: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case crystallize = "Crystallize"
    case edges = "Edges"
    case gaussianBlur = "Gaussian Blur"
    case pixellate = "Pixellate"
    case sepiaTone = "Sepia Tone"
    case unsharpMask = "Unsharp Mask"
    case vignette = "Vignette"
    case pinchDistortion = "Pinch Distortion"
    case photoEffectNoir = "Photo Effect Noir"
    case morphologyMaximum = "Morphology Maximum"
    
    var type: CIFilter {
        switch self {
        case .crystallize:
            return CIFilter.crystallize()
        case .edges:
            return CIFilter.edges()
        case .gaussianBlur:
            return CIFilter.gaussianBlur()
        case .pixellate:
            return CIFilter.pixellate()
        case .sepiaTone:
            return CIFilter.sepiaTone()
        case .unsharpMask:
            return CIFilter.unsharpMask()
        case .vignette:
            return CIFilter.vignette()
        case .pinchDistortion:
            return CIFilter.pinchDistortion()
        case .photoEffectNoir:
            return CIFilter.photoEffectNoir()
        case .morphologyMaximum:
            return CIFilter.morphologyMaximum()
        }
    }
    
    static func name(from typeName: String) -> String? {
        switch typeName {
        case CIFilter.crystallize().name:
            return Self.crystallize.rawValue
        case CIFilter.edges().name:
            return Self.edges.rawValue
        case CIFilter.gaussianBlur().name:
            return Self.gaussianBlur.rawValue
        case CIFilter.pixellate().name:
            return Self.pixellate.rawValue
        case CIFilter.sepiaTone().name:
            return Self.sepiaTone.rawValue
        case CIFilter.unsharpMask().name:
            return Self.unsharpMask.rawValue
        case CIFilter.vignette().name:
            return Self.vignette.rawValue
        case CIFilter.pinchDistortion().name:
            return Self.pinchDistortion.rawValue
        case CIFilter.photoEffectNoir().name:
            return Self.photoEffectNoir.rawValue
        case CIFilter.morphologyMaximum().name:
            return Self.morphologyMaximum.rawValue
        default:
            return nil
        }
    }
}

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    private let filterChangesForRequestReview = 20
    
    @State private var currentFilter: CIFilter = .crystallize()
    private let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                VStack {
                    if let name = SupportedFilters.name(from: currentFilter.name) {
                        Text(name)
                            .padding(.bottom)
                            .font(.title)
                    }
                    
                    
                    let inputKeys = currentFilter.inputKeys
                    
                    if inputKeys.contains(CIParameters.intensity.kCIInputKey) {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity, applyProcessing)
                            .disabled(processedImage == nil)
                    }
                    
                    if inputKeys.contains(CIParameters.radius.kCIInputKey) {
                        Text("Radius")
                        Slider(value: $filterRadius)
                            .onChange(of: filterRadius, applyProcessing)
                            .disabled(processedImage == nil)
                    }
                    
                    if inputKeys.contains(CIParameters.scale.kCIInputKey) {
                        Text("Scale")
                        Slider(value: $filterScale)
                            .onChange(of: filterScale, applyProcessing)
                            .disabled(processedImage == nil)
                    }
                }
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(processedImage == nil)
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                ForEach(SupportedFilters.allCases) { filter in
                    Button(filter.rawValue) {
                        setFilter(filter.type)
                    }
                }
            }
        }
    }
    
    private func changeFilter() {
        showingFilters = true
    }
    
    private func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self),
                  let inputImage = UIImage(data: imageData) else {
                return
            }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    private func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(CIParameters.intensity.kCIInputKey) {
            currentFilter.setValue(filterIntensity * CIParameters.intensity.valueMultiplier, forKey: CIParameters.intensity.kCIInputKey)
        }
        
        if inputKeys.contains(CIParameters.radius.kCIInputKey) {
            currentFilter.setValue(filterRadius * CIParameters.radius.valueMultiplier, forKey: CIParameters.radius.kCIInputKey)
        }
        if inputKeys.contains(CIParameters.scale.kCIInputKey) {
            currentFilter.setValue(filterScale * CIParameters.scale.valueMultiplier, forKey: CIParameters.scale.kCIInputKey)
        }
        
        guard let outputImage = currentFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor private func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount >= filterChangesForRequestReview {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}

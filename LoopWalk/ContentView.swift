import SwiftUI
import MapboxMaps

struct ContentView: View {
    @State private var mapView: MapView?

    var body: some View {
        MapViewWrapper(mapView: $mapView)
            .onAppear {
                setupMap()
            }
    }

    private func setupMap() {
        let myResourceOptions = ResourceOptions(accessToken: "YOUR_MAPBOX_ACCESS_TOKEN")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)

        let mapView = MapView(frame: UIScreen.main.bounds, mapInitOptions: myMapInitOptions)
        self.mapView = mapView

        mapView.mapboxMap.onNext(event: .mapLoaded) { _ in
            print("Map has loaded.")
            addFillExtrusionLayer(mapView: mapView)
        }
    }

    private func addFillExtrusionLayer(mapView: MapView) {
        let style = mapView.mapboxMap.style

        do {
            let layerIdentifiers = try style.allLayerIdentifiers
            for layer in layerIdentifiers {
                if let source = try? style.source(withId: layer.id) {
                    if source.id.starts(with: "composite") {
                        if source.type == .vector {
                            // Assuming "composite" is the source name and "building" is the source layer name
                            self.add3DLayer(mapView: mapView, source: source.id, sourceLayer: "building")
                            break
                        }
                    }
                }
            }
        } catch {
            print("Error fetching layers: \(error)")
        }
    }

    private func add3DLayer(mapView: MapView, source: String, sourceLayer: String) {
        var layer = FillExtrusionLayer(id: "3d-buildings")
        layer.source = source
        layer.sourceLayer = sourceLayer
        layer.filter = Exp(.eq) {
            "$type"
            "Polygon"
        }
        layer.fillExtrusionHeight = .expression(Exp(.get) { "height" })
        layer.fillExtrusionBase = .expression(Exp(.get) { "min_height" })
        layer.fillExtrusionColor = .constant(StyleColor(.brown))

        do {
            try mapView.mapboxMap.style.addLayer(layer)
        } catch {
            print("Failed to add layer: \(error)")
        }
    }
}

struct MapViewWrapper: UIViewRepresentable {
    @Binding var mapView: MapView?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let mapView = mapView {
            view.addSubview(mapView)
            mapView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let mapView = mapView else { return }

        // Remove all subviews
        for subview in uiView.subviews {
            subview.removeFromSuperview()
        }

        // Re-add the updated mapView
        uiView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: uiView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
        ])
    }
}

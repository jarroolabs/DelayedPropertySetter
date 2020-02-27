class DelayedPropertySetter<Root> {
    typealias PropertySetter = (inout Root) -> Void

    private var propertySetters = [AnyKeyPath: PropertySetter]()
    private var root: Root?

    subscript<Value>(keyPath: KeyPath<Root, Value>) -> Value? {
        root?[keyPath: keyPath]
    }

    func set(to newRoot: Root) {
        root = newRoot
        runPropertySettersIfNecessary()
    }

    func setProperty<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        to: Value
    ) {
        setProperty(keyPath, via: { root in
            root[keyPath: keyPath] = to
        })
    }

    func setProperty<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        via customPropertySetter: @escaping PropertySetter
    ) {
        propertySetters[keyPath] = customPropertySetter
        runPropertySettersIfNecessary()
    }

    private func runPropertySettersIfNecessary() {
        guard var value = self.root else { return /* not necessary */ }
        propertySetters.values.forEach { propertySetter in
            propertySetter(&value)
        }
    }
}

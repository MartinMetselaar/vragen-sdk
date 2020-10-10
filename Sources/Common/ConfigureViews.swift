protocol ConfigureViews {
    func configureViews()
    func configureView()
    func configureSubviews()
    func configureConstaints()

}

extension ConfigureViews {
    func configureViews() {
        configureView()
        configureSubviews()
        configureConstaints()
    }
}

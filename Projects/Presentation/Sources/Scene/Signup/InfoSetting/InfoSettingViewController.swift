import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

final public class InfoSettingViewController: BaseViewController<InfoSettingViewModel> {
    public var email: String = ""
    public var password: String = ""
    public var verificationCode: String = ""

    private var gradeRelay = BehaviorRelay<String>(value: "")
    private var classRelay = BehaviorRelay<String>(value: "")
    private var numberRelay = BehaviorRelay<String>(value: "")
    private let actualNextButtonTap = PublishSubject<Void>()

    private let titleLabel = PiCKLabel(
        text: "PiCK에 회원가입하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "학번과 이름을 입력해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )
    private let numberTitleLabel = PiCKLabel(
        text: "학번",
        textColor: .black,
        font: .pickFont(.label1)
    )
    private let selectButton = SchoolNumberSelectButton(type: .system)
    private let gradeLabel = PiCKLabel(
        text: "학년",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let classSelectButton = SchoolNumberSelectButton(type: .system)
    private let classNumberLabel = PiCKLabel(
        text: "반",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let numberSelectButton = SchoolNumberSelectButton(type: .system)
    private let schoolNumberLabel = PiCKLabel(
        text: "번",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private lazy var studentNumberStackView = UIStackView(arrangedSubviews: [
        selectButton,
        gradeLabel,
        classSelectButton,
        classNumberLabel,
        numberSelectButton,
        schoolNumberLabel
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let nameTextField = PiCKTextField(
        titleText: "이름",
        placeholder: "이름을 입력해주세요",
        buttonIsHidden: true
    )
    private let nextButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )

    public override func attribute() {
        super.attribute()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    public override func bind() {
        let input = InfoSettingViewModel.Input(
            email: email,
            password: password,
            verificationCode: verificationCode,
            grade: gradeRelay.asObservable(),
            selectGradeButtonDidTap: selectButton.buttonTap.asObservable(),
            classNumber: classRelay.asObservable(),
            selectClassButtonDidTap: classSelectButton.buttonTap.asObservable(),
            number: numberRelay.asObservable(),
            selectNumberButtonDidTap: numberSelectButton.buttonTap.asObservable(),
            name: nameTextField.rx.text.orEmpty.asObservable(),
            nextButtonDidTap: actualNextButtonTap.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isNextButtonEnabled
            .asObservable()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)

        output.signupResult
            .asObservable()
            .withUnretained(self)
            .bind { _, isSuccess in
                if isSuccess {
                    print("회원가입 성공!")
                } else {
                    print("회원가입 실패")
                }
            }
            .disposed(by: disposeBag)

        output.errorToastMessage
            .asObservable()
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .bind { owner, message in
                owner.presentErrorToast(message: message)
            }
            .disposed(by: disposeBag)
    }

    public override func bindAction() {
        selectButton.buttonTap
            .bind { [weak self] in
                self?.presentStudentInfoAlert()
            }.disposed(by: disposeBag)

        classSelectButton.buttonTap
            .bind { [weak self] in
                self?.presentStudentInfoAlert()
            }.disposed(by: disposeBag)

        numberSelectButton.buttonTap
            .bind { [weak self] in
                self?.presentStudentInfoAlert()
            }.disposed(by: disposeBag)

        nextButton.buttonTap
            .withLatestFrom(Observable.combineLatest(
                gradeRelay.asObservable(),
                classRelay.asObservable(),
                numberRelay.asObservable(),
                nameTextField.rx.text.orEmpty.asObservable()
            ))
            .bind { [weak self] grade, classNumber, number, name in
                guard let self = self else { return }
                guard !grade.isEmpty && !classNumber.isEmpty && !number.isEmpty && !name.isEmpty else { return }

                let infoCheckView = InfoCheckView(
                    grade: grade,
                    classNumber: classNumber,
                    number: number,
                    name: name
                ) {
                    self.actualNextButtonTap.onNext(())
                }

                self.present(infoCheckView, animated: true)
            }
            .disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            numberTitleLabel,
            studentNumberStackView,
            nameTextField,
            nextButton
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        numberTitleLabel.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(46.5)
            $0.leading.equalToSuperview().inset(24)
        }
        studentNumberStackView.snp.makeConstraints {
            $0.top.equalTo(numberTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(studentNumberStackView.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension InfoSettingViewController {
    private func presentStudentInfoAlert() {
        let alert = PiCKApplyTimePickerAlert(type: .studentInfo)
        alert.selectedStudentInfo = { [weak self] grade, classNum, number in
            self?.gradeRelay.accept("\(grade)")
            self?.classRelay.accept("\(classNum)")
            self?.numberRelay.accept("\(number)")

            self?.selectButton.setup(text: "\(grade)")
            self?.classSelectButton.setup(text: "\(classNum)")
            self?.numberSelectButton.setup(text: "\(number)")
        }
        self.presentAsCustomDents(view: alert, height: 406)
    }
}

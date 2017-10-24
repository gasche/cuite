open Qt
open Cuite

let sprintf = Printf.sprintf
let num_grid_rows = 3
let num_buttons = 4

let root = ref []

let create_menu () =
  let bar = QMenuBar.new' None in
  let file = QMenu.new' None in
  QMenu.setTitle file "&File";
  let _exit = QMenu.addAction file "E&xit" in
  ignore (QMenuBar.addMenu bar file : _ Qt.t);
  bar

let create_horizontal_group_box () =
  let box = QGroupBox.new'1 "Horizontal layout" None in
  let layout = QHBoxLayout.new'1 None in
  let btn' = ref [] in
  for i = 1 to num_buttons do
    let btn = QPushButton.new' None in
    btn' := btn :: !btn';
    QAbstractButton.setText btn (sprintf "Button %d" i);
    QLayout.addWidget layout btn
  done;
  QWidget.setLayout box (Some layout);
  box, !btn'

let create_grid_group_box () =
  let box = QGroupBox.new'1 "Grid Layout" None in
  let layout = QGridLayout.new' None in
  for i = 1 to num_grid_rows do
    let label = QLabel.new'1 (sprintf "Line %d:" i) None Qflags.empty in
    let lineEdit = QLineEdit.new' None in
    QGridLayout.addWidget layout label i 0 Qflags.empty;
    QGridLayout.addWidget layout lineEdit i 1 Qflags.empty;
  done;
  let small_editor = QTextEdit.new' None in
  QTextEdit.setPlainText small_editor "This widget takes up about two thirds of the grid layout.";
  QGridLayout.addWidget1 layout small_editor 0 2 4 1 Qflags.empty;
  QGridLayout.setColumnStretch layout 1 10;
  QGridLayout.setColumnStretch layout 2 20;
  QWidget.setLayout box (Some layout);
  box

let create_form_group_box () =
  let group = QGroupBox.new'1 "Form layout" None in
  let form = QFormLayout.new' None in
  QWidget.setLayout group (Some form);
  QFormLayout.addRow form (QLabel.new'1 "Line 1:" None Qflags.empty) (QLineEdit.new' None);
  QFormLayout.addRow form (QLabel.new'1 "Line 2, long text:" None Qflags.empty) (QComboBox.new' None);
  QFormLayout.addRow form (QLabel.new'1 "Line 3:" None Qflags.empty) (QSpinBox.new' None);
  group

let create_dialog () =
  let dialog = QWidget.new' None (*Qflags.empty*) in
  let menu_bar = create_menu () in
  let hbox, btns = create_horizontal_group_box () in
  let grid = create_grid_group_box () in
  let form = create_form_group_box () in
  let big_editor = QTextEdit.new' None in
  QTextEdit.setPlainText big_editor "This widget takes up all the remaining space in the top-level layout";
  let mainlayout = QVBoxLayout.new' () in
  QLayout.setMenuBar mainlayout menu_bar;
  QLayout.addWidget mainlayout hbox;
  QLayout.addWidget mainlayout grid;
  QLayout.addWidget mainlayout form;
  QLayout.addWidget mainlayout big_editor;
  (* button box *)
  QWidget.setLayout dialog (Some mainlayout);
  QWidget.setWindowTitle dialog "Basic Layouts";
  List.iter (fun btn ->
      Qt.connect_slot' btn (QPushButton.signal'clicked1())
        dialog
        (Qt.slot_ignore (QWidget.slot'close1 ()))

    ) btns;
  dialog

let () =
  let app = QApplication.new' () in
  (*let dialog' = create_dialog () in
    Qt.delete dialog';
    assert (Qt.is_deleted dialog');*)
  let dialog = create_dialog () in
  QWidget.show dialog;
  ignore (QApplication.exec () : int);
  root := [Obj.repr app; Obj.repr dialog];

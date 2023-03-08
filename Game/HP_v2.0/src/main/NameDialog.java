package main;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class NameDialog extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JTextField nameTextField;
    private JLabel instructions;

    private static String name;

    public NameDialog() {
        setContentPane(contentPane);
        setModal(true);
        getRootPane().setDefaultButton(buttonOK);
        nameTextField.requestFocus();
        setLocationRelativeTo(null);
        if (Settings.debugMode)
            nameTextField.setText(Utils.Debug.randomName());

        buttonOK.addActionListener(e -> onOK());

        buttonCancel.addActionListener(e -> onCancel());

        // call onCancel() when cross is clicked
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                onCancel();
            }
        });
    }

    private void onOK() {
        name = nameTextField.getText();
        if (name != null && name.length() > 2)
            dispose();
        else {
            instructions.setText("Enter name you muggle!");
            instructions.setForeground(Color.RED);
        }
    }

    private void onCancel() {
        // add your code here if necessary
        dispose();
    }

    public static String requestUserName() {
        NameDialog dialog = new NameDialog();
        dialog.pack();
        dialog.setVisible(true);
        return name;
    }
}

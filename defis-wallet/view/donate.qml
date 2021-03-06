import QtQuick 2.11
import QtQuick.Controls 1.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import "controls"
import Grimm.Wallet 1.0

Rectangle {

    anchors.fill: parent
    gradient: Gradient {
        GradientStop { position: 0.2; color: "#010202" }
        GradientStop { position: 1.0; color: "#101615" }
    }


    SettingsViewModel {id: viewModel}



    function handleMousePointer(mouse, element) {
        if (element.parent.linkAt(mouse.x, mouse.y).length) {
            element.cursorShape = Qt.PointingHandCursor;
        } else {
            element.cursorShape = Qt.ArrowCursor;
        }
    }


    ColumnLayout {
        id: mainColumn
        anchors.fill: parent
        spacing: 20
        anchors.bottomMargin: 30
        anchors.topMargin: 25

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            SFText {
                Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                font.pixelSize: 36
                color: Style.content_main
                //: settings tab title
                //% "Settings"
                text: "Custom assetchain assets CAC"
            }

            SFText {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                bottomPadding: 7
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 14
                color: Style.content_secondary
                //: settings tab, version label
                //% "Version: "
                text: qsTrId("settings-version") + viewModel.version
            }
        }


        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                RowLayout {
                    width: mainColumn.width
                    spacing: 10





                    ColumnLayout {
                        Layout.preferredWidth: mainColumn.width
                        Layout.alignment: Qt.AlignTop | Qt.AlignRight



                        Item {
                            Layout.preferredHeight: 10
                        }

                        Rectangle {
                            id: nodeBlock
                            Layout.fillWidth: true
                            radius: 10
                            color: Style.navigation_background
                            Layout.preferredHeight: viewModel.localNodeRun ? 800 : (nodeAddressError.visible ? 285 : 240)

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 30
                                spacing: 10

                                RowLayout {
                                    Layout.preferredHeight: 16
                                    Layout.topMargin: 15

                                    CustomSwitch {
                                        id: localNodeRun
                                        Layout.fillWidth: true
                                        //: settings tab, node section, run node label
                                        //% "Run full node"
                                        text: qsTrId("settings-local-node-run-checkbox")
                                        font.pixelSize: 14
                                        width: parent.width
                                        checked: viewModel.localNodeRun
                                        Binding {
                                            target: viewModel
                                            property: "localNodeRun"
                                            value: localNodeRun.checked
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.preferredHeight: 16
                                    visible: viewModel.localNodeRun

                                    SFText {
                                        Layout.fillWidth: true;
                                        //: settings tab, node section, port label
                                        //% "Port"
                                        text: qsTrId("settings-local-node-port")
                                        color: Style.content_secondary
                                        font.pixelSize: 14
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    SFTextInput {
                                        id: localNodePort
                                        Layout.preferredWidth: nodeBlock.width * 0.55
                                        Layout.alignment: Qt.AlignRight
                                        activeFocusOnTab: true
                                        font.pixelSize: 14
                                        color: Style.content_main
                                        text: viewModel.localNodePort
                                        validator: IntValidator {
                                            bottom: 1
                                            top: 65535
                                        }
                                        Binding {
                                            target: viewModel
                                            property: "localNodePort"
                                            value: localNodePort.text
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.preferredHeight: 16
                                    visible: !viewModel.localNodeRun
                                    SFText {
                                        Layout.fillWidth: true
                                        //: settings tab, node section, address label
                                        //% "ip:port"
                                        text: qsTrId("settings-remote-node-ip-port")
                                        color: Style.content_secondary
                                        font.pixelSize: 14
                                    }

                                    SFTextInput {
                                        id: nodeAddress
                                        Layout.fillWidth: true
                                        Layout.maximumWidth: nodeBlock.width * 0.6
                                        Layout.minimumWidth: nodeBlock.width * 0.5
                                        focus: true
                                        activeFocusOnTab: true
                                        font.pixelSize: 14
                                        color: Style.content_main
                                        validator: RegExpValidator { regExp: /^(\s|\x180E)*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|([\w.-]+(?:\.[\w\.-]+)+))(:([1-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]))?(\s|\x180E)*$/ }
                                        text: viewModel.nodeAddress
                                        Binding {
                                            target: viewModel
                                            property: "nodeAddress"
                                            value: nodeAddress.text.trim()
                                        }
                                    }
                                }

                                RowLayout {
                                    id: nodeAddressError
                                    Layout.preferredHeight: 16
                                    visible: !viewModel.localNodeRun && (!viewModel.isValidNodeAddress || !nodeAddress.acceptableInput)

                                    Item {
                                        Layout.fillWidth: true;
                                    }

                                    SFText {
                                        Layout.preferredWidth: nodeBlock.width * 0.6
                                        color: Style.validator_error
                                        font.pixelSize: 14
                                        font.italic: true
                                        //: settings tab, node section, on address error
                                        //% "Invalid address"
                                        text: qsTrId("settings-remote-node-ip-port-error")
                                    }
                                }

                                Item {
                                                      Layout.preferredHeight: 12
                                                      visible: viewModel.localNodeRun
                                                  }



                                                  RowLayout {
                                                      Layout.preferredHeight: 16
                                                      visible: viewModel.localNodeRun

                                                      SFText {
                                                          Layout.fillWidth: true;
                                                          //: settings tab, node section, port label
                                                          //% "Port"
                                                          text: "CAC symbol"
                                                          color: Style.content_secondary
                                                          font.pixelSize: 14
                                                      }

                                                      Item {
                                                          Layout.fillWidth: true
                                                      }

                                                      SFTextInput {
                                                          id: localNodecac_symbol
                                                          Layout.preferredWidth: nodeBlock.width * 0.55
                                                          Layout.alignment: Qt.AlignRight
                                                          activeFocusOnTab: true
                                                          font.pixelSize: 14
                                                          color: Style.content_main
                                                          text: viewModel.localNodecac_symbol

                                                          }
                                                          Binding {
                                                              target: viewModel
                                                              property: "localNodecac_symbol"
                                                              value: localNodecac_symbol.text
                                                          }
                                                      }

                                                      RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                          SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "CAC 1st block pre-mine (in Coins)"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_premineid
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_premineid

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_premineid"
                                                                  value: cac_premineid.text
                                                              }
                                                          }


                                                          RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                          SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "CAC coinbase emission in a single block"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_blockrewardid
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_blockrewardid

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_blockrewardid"
                                                                  value: cac_blockrewardid.text
                                                              }
                                                          }

                                                          RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                          SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "CAC halving after block height"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_drop0id
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_drop0id

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_drop0id"
                                                                  value: cac_drop0id.text
                                                              }
                                                          }

                                                           RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                          SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "CAC cycle for next halvings (in heights)"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_drop1id
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_drop1id

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_drop1id"
                                                                  value: cac_drop1id.text
                                                              }
                                                          }

                                                           RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                          SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "CAC Coinbase coins can spend after blocks"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_coinbasematurityid
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_coinbasematurityid

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_coinbasematurityid"
                                                                  value: cac_coinbasematurityid.text
                                                              }
                                                          }

                                                           RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                           SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "CAC Standart coins can spend after blocks"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_standartmaturityid
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_standartmaturityid

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_standartmaturityid"
                                                                  value: cac_standartmaturityid.text
                                                              }
                                                          }

                                                        RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                           SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "Block time in sec"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_blocktimeid
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_blocktimeid

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_blocktimeid"
                                                                  value: cac_blocktimeid.text
                                                              }
                                                         }

                                                      RowLayout {
                                                          Layout.preferredHeight: 16
                                                          visible: viewModel.localNodeRun

                                                           SFText {
                                                              Layout.fillWidth: true;
                                                              //: settings tab, node section, port label
                                                              //% "Port"
                                                              text: "Start difficulty (0 for cpu mining start)"
                                                              color: Style.content_secondary
                                                              font.pixelSize: 14
                                                          }

                                                          Item {
                                                              Layout.fillWidth: true
                                                          }

                                                          SFTextInput {
                                                              id: cac_diffid
                                                              Layout.preferredWidth: nodeBlock.width * 0.55
                                                              Layout.alignment: Qt.AlignRight
                                                              activeFocusOnTab: true
                                                              font.pixelSize: 14
                                                              color: Style.content_main
                                                              text: viewModel.cac_diffid

                                                              }
                                                              Binding {
                                                                  target: viewModel
                                                                  property: "cac_diffid"
                                                                  value: cac_diffid.text
                                                              }
                                                          }




                              SFText {
                                    Layout.topMargin: 15
                                    //: settings tab, node section, peers label
                                    //% "Peers"
                                    text: qsTrId("settings-peers-title")
                                    color: Style.content_main
                                    font.pixelSize: 18
                                    font.styleName: "Bold"; font.weight: Font.Bold
                                    visible: viewModel.localNodeRun
                                }

                                RowLayout {
                                    Layout.minimumHeight: 25
                                    Layout.maximumHeight: 41
                                    Layout.preferredHeight: 25
                                    spacing: 10
                                    visible: viewModel.localNodeRun

                                    SFTextInput {
                                        Layout.preferredWidth: nodeBlock.width * 0.7
                                        id: newLocalNodePeer
                                        activeFocusOnTab: true
                                        font.pixelSize: 14
                                        color: Style.content_main
                                        validator: RegExpValidator { regExp: /^(\s|\x180E)*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|([\w.-]+(?:\.[\w\.-]+)+))(:([1-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]))?(\s|\x180E)*$/ }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Image {
                                        Layout.alignment: Qt.AlignRight
                                        Layout.preferredHeight: 16
                                        Layout.preferredWidth: 16
                                        source: "qrc:/assets/icon-add-green.svg"
                                        MouseArea {
                                            anchors.fill: parent
                                            acceptedButtons: Qt.LeftButton
                                            cursorShape: newLocalNodePeer.acceptableInput ? Qt.PointingHandCursor : Qt.ArrowCursor
                                            onClicked: {
                                                if (newLocalNodePeer.acceptableInput) {
                                                    viewModel.addLocalNodePeer(newLocalNodePeer.text.trim());
                                                    newLocalNodePeer.clear();
                                                }
                                            }
                                        }
                                    }
                                }

                                ListView {
                                    visible: viewModel.localNodeRun
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    model: viewModel.localNodePeers
                                    clip: true
                                    delegate: RowLayout {
                                        width: parent.width
                                        height: 36

                                        SFText {
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignVCenter
                                            text: modelData
                                            font.pixelSize: 14
                                            color: Style.content_main
                                            height: 16
                                            elide: Text.ElideRight
                                        }

                                        CustomButton {
                                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                            Layout.minimumHeight: 20
                                            Layout.minimumWidth: 20
                                            shadowRadius: 5
                                            shadowSamples: 7
                                            Layout.margins: shadowRadius
                                            leftPadding: 5
                                            rightPadding: 5
                                            textOpacity: 0
                                            icon.source: "qrc:/assets/icon-delete.svg"
                                            enabled: localNodeRun.checked
                                            onClicked: viewModel.deleteLocalNodePeer(index)
                                        }
                                    }
                                    ScrollBar.vertical: ScrollBar {}
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.preferredHeight: 42
                                    CustomButton {
                                        Layout.preferredHeight: 38
                                        Layout.preferredWidth: 125
                                        leftPadding: 25
                                        rightPadding: 25
                                        spacing: 12
                                        //: settings tab, node section, cancel button
                                        //% "cancel"
                                        text: qsTrId("settings-undo")
                                        icon.source: "qrc:/assets/icon-cancel-white.svg"
                                        enabled: {
                                            viewModel.isChanged
                                            && nodeAddress.acceptableInput
                                            && localNodePort.acceptableInput
                                        }
                                        onClicked: viewModel.undoChanges()
                                    }

                                    Item {
                                        Layout.maximumWidth: 30
                                        Layout.fillWidth: true
                                    }

                                    PrimaryButton {
                                        Layout.preferredHeight: 38
                                        Layout.preferredWidth: 125
                                        leftPadding: 25
                                        rightPadding: 25
                                        spacing: 12
                                        //: settings tab, node section, apply button
                                        //% "apply"
                                        text: qsTrId("settings-apply")
                                        icon.source: "qrc:/assets/icon-done.svg"
                                        enabled: {
                                            viewModel.isChanged
                                            && nodeAddress.acceptableInput
                                            && localNodePort.acceptableInput
                                            && (localNodeRun.checked ? (viewModel.localNodePeers.length > 0) : viewModel.isValidNodeAddress)
                                        }
                                        onClicked: viewModel.applyChanges()
                                    }
                                }
                            }
                        }







                    }

                }

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
            }
        }
    }
}

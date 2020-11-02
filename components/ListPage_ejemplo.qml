import QtQuick 2.12


  Item{
    id: listpage     
    property var itemWidth : 600/itemsRow
    property var itemHeight : itemWidth
    Keys.onPressed: {
      //Back to Home            
      if (api.keys.isCancel(event)) {
          event.accepted = true;
          // gameView.model = currentCollection.games
          // gameViewStyle = 'standard'
          searchValue=''
          // header__search_input.focus = false
          // gameView.focus = true 
          
          header__search_input.text='Search...'
          navigate('HomePage');
          return;
      }  
      
    }
 
    Rectangle {
        id: header
        color: Qt.rgba(0, 0, 0, .5)
        width: headerCSS.width
        height: 50
        anchors.top: parent.top
        // visible:false
        clip:true
        
        Rectangle{
          id: header_inner
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.topMargin: 0
          anchors.leftMargin: 30          
          color:"transparent"
          width:parent.width-48
          height: 40
          
          Rectangle{
            id: header__system
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 0
            width:  40
            height: 40  
            color:"transparent"    
            visible:false      
            Image {
                id: header__system_logo
                width:parent.width
                height: parent.width
                fillMode: Image.PreserveAspectFit
                //source: "../assets/images/systems/" + currentCollection.shortName + ".png"
                source: "../assets/images/"+theme.system_icon
                asynchronous: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            
            
            Text{
              text: currentCollection.name
              anchors.left: header__system_logo.right
              anchors.leftMargin: 12
              color: theme.title
              font.pixelSize: 22
              anchors.verticalCenter: parent.verticalCenter
              width:300       
              elide: Text.ElideRight       
            }
          }    
          
          Rectangle{
            id: header__filters
            color:"transparent"
            anchors.top: parent.top
            anchors.right: parent.right
            height: 32
            width:300
            
            Rectangle{
              id: header__search
              color:"white";
              anchors.top: parent.top
              anchors.topMargin: 10 
              anchors.right: parent.right
              width:200
              height: 30 
              //anchors.verticalCenter: parent.verticalCenter                
              border.color: theme.text
              border.width:1
              radius:2
              visible:true
              
                Rectangle{
                    id: header__search_button
                    height:16
                    width:16
                    color:"#444"
                    radius:20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right 
                    anchors.rightMargin: 6 
                    visible: currentPage === 'ListPage' ? 1 : 0            
                    Text{
                         text:"R2"
                         color:"white"                    
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.horizontalCenter: parent.horizontalCenter
                         font.pixelSize:8
                    }
                }              
              
                  TextInput{
                      id:header__search_input
                      text:"Search.."
                      width:parent.width
                      height: parent.height                   
                      anchors.top: parent.top
                      anchors.left: parent.left
                      anchors.leftMargin: 6 
                      anchors.topMargin: 8
                      color: theme.text
                      onTextEdited: {
                          gameView.currentIndex = 0 //We move the highlight to the first item
                          searchValue = header__search_input.text
                          gameView.model = searchGames
                      }
                      
                        Keys.onPressed: {
                          if (api.keys.isAccept(event)) {
                              navigate('ListPage');
                              return;
                          }  
                          if (event.key == Qt.Key_Down) {
                              navigate('ListPage');  
                              return;
                          }
                          // if (api.keys.isCancel(event)) {
                          //     searchValue=''
                          //     header__search_input.text='Search...'                            
                          //     gameView.focus = true                           
                          //     return;
                          // }  
                          
                          
                        }
                       
                  }
                            // searchValue = "ninja"
                            // gameView.model = searchGames              
              
            }              
          }      
            

          
        }
        
    }
       
    Rectangle {
        id: main
        color: Qt.rgba(0, 0, 0, .5)
        width: wrapperCSS.width
        height: mainCSS.height
        anchors.top: header.bottom
        
      
          Rectangle {
              id: menu
          
              property real contentWidth: width - vpx(100)
          
              color: "#555"
          
              width: parent.width * 0.5
              anchors.top: parent.top
              anchors.bottom: parent.bottom

              Image {
                  id: collectionLogo
          
                  width: 200          
                  fillMode: Image.PreserveAspectFit
                  source: "../assets/images/logos/"+currentCollection.shortName+".png"
                  asynchronous: true          
                  anchors.horizontalCenter: parent.horizontalCenter
                  anchors.top: parent.top
                  anchors.topMargin: 20
              }
                        
              ListView {
                  id: gameView
                  model: currentCollection.games
                  delegate: gameViewDelegate
                  width: parent.contentWidth
                  anchors.horizontalCenter: parent.horizontalCenter
                  anchors.top: collectionLogo.bottom
                  anchors.bottom: parent.bottom
                  anchors.margins: vpx(50)
          
                  focus: true
              }         
              
              Component {
                  id: gameViewDelegate
              
                  Text {
                      text: modelData.title
              
                      // white, 20px, condensed font
                      color: ListView.isCurrentItem ? "orange" : "white"
                      font.family: globalFonts.condensed
                      font.pixelSize: vpx(20)
              
                      // the size of the whole text box,
                      // a bit taller than the text size for a nice padding
                      width: ListView.view.width
                      height: vpx(36)
                      // align the text vertically in the middle of the text area
                      verticalAlignment: Text.AlignVCenter
                      // if the text is too long, end it with ellipsis (three dots)
                      elide: Text.ElideRight
                  }
              }               
          }

          
          Rectangle {
              id: content
      
              color: "#222"
      
              anchors.left: menu.right
              anchors.right: parent.right
              anchors.top: parent.top
              anchors.bottom: parent.bottom
              
              
              
          }          
                  
        
    }  
    
     Footer{
      id: footer
    }   

}
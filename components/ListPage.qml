import QtQuick 2.12


  Item{
    id: listpage     
    property var itemWidth : 600/itemsRow
    property var itemHeight : itemWidth



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
            id: games
            visible: true
            color: "transparent"
            width: parent.width
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        
             
            
            GridView {
                id: gameView
                width: parent.width;
                height: parent.height
                model: currentCollection.games
                delegate: gameViewDelegate
                clip:true
                anchors.left: parent.left
                anchors.leftMargin: 22
                anchors.top: parent.top
                anchors.bottom: parent.bottom        
                focus: currentPage === 'ListPage' ? true : false ;
                
                snapMode: ListView.SnapOneItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                
                Keys.onUpPressed:       { moveCurrentIndexUp();navSound.play(); }
                Keys.onDownPressed:     { moveCurrentIndexDown();navSound.play(); }
                Keys.onLeftPressed:     { moveCurrentIndexLeft();navSound.play(); }
                Keys.onRightPressed:    { moveCurrentIndexRight();navSound.play(); }
                cellWidth: itemWidth
                cellHeight: itemHeight
                
                Component {
                    id: gameViewDelegate 
                    Item
                    {
                      id: delegateContainer
                      property bool selected: delegateContainer.GridView.isCurrentItem
                      property var gameViewStyle : 'standard'
                      Keys.onPressed: {
                        //Launch game
                        if (api.keys.isAccept(event)) {
                            event.accepted = true;
                            currentGameIndex = index
                            launchSound.play()
                            currentGame.launch();                            
                            return;
                        }  
                        
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
                        
                        //toggleItemsRow     
                        if (api.keys.isFilters(event)) {
                            event.accepted = true;
                            toggleItemsRow();
                            
                            toggleSound.play()
                            //Show only current favs, not working right now...
                            // if ( gameViewStyle === 'standard'){
                            //   gameView.model = currentFavorites
                            //   gameViewStyle = 'favs'
                            //   return;
                            // }else{
                            //   gameView.model = currentCollection.games
                            //   gameViewStyle = 'standard'
                            // }
                            
                        }  
                        //Favorite
                        if (api.keys.isDetails(event)) {
                            event.accepted = true;
                            favSound.play()                            
                            currentGameIndex = index
                            currentGame.favorite = !currentGame.favorite
                            return;
                        }                        
                        //Next collection
                        if (api.keys.isNextPage(event)) {
                            event.accepted = true;
                            goBackSound.play()
                            currentCollectionIndex = currentCollectionIndex+1
                           
                            return;
                        }  
                        
                        //Prev collection
                        if (api.keys.isPrevPage(event)) {
                            event.accepted = true;
                            goBackSound.play()
                            currentCollectionIndex = currentCollectionIndex-1
                            return;
                        }  
                        
                        //Search
                        if (api.keys.isPageDown(event)) {
                            event.accepted = true;
                            goBackSound.play()
                            searchValue = ''
                            header__search_input.clear()            
                            header__search_input.focus = true
                            
                            return;
                        }  
                        
                        
                                    
                      }                          
                    
                      Rectangle{
                        color:"transparent"
                        width: itemWidth
                        height: itemHeight
                                                
                        Image {
                            id: game_screenshot
                            width: itemWidth    
                            height:   itemHeight
                            //fillMode: Image.PreserveAspectFit
                            asynchronous: true    
                            source: {
                                if (currentCollection.shortName !== "android") {
                                    if (modelData.assets.screenshots[0]) {
                                        return modelData.assets.screenshots[0]
                                    }
                                    return ""
                                }
                                return ""
                            }                                                               
                        }      
                        
                        Image {
                            id: gamelogo
    
                            width: parent.width
                            height: parent.height
                            anchors {
                                fill: parent
                                margins: vpx(6)
                            }
    
                            asynchronous: true
    
                            //opacity: 0
                            source: {
                                if (currentCollection.shortName == "android") {
                                    if (modelData.assets.boxFront) {
                                        return modelData.assets.boxFront
                                    }
                                    return ""
                                }
                                if (modelData.assets.logo) {
                                    return modelData.assets.logo
                                }
                                return ""
                            }
                            sourceSize { width: 256; height: 256 }
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            visible: gamelogo.source !== ""
                            z:8
                        }
                                                                       
                        Rectangle{
                          id: game__is_selected
                          width:parent.width
                          height:parent.height
                          color:"transparent"
                          opacity:1     
                          border.color: selected ? "#10adc5" : wrapperCSS.background
                          border.width: 4                                                
                        }
                        
                        
                        Canvas {
                            id: game__is_fav
                            // canvas size
                            width: 60; height: 60;
                            opacity:0.8
                            anchors {
                                left: parent.left; 
                                top: parent.top;
                            }
                            anchors.leftMargin: 4
                            anchors.topMargin: 4                          
                            visible: modelData.favorite && currentCollection.shortName !== "all-favorites"                            
                            // handler to override for drawing
                            onPaint: {
                                // get context to draw with
                                var ctx = getContext("2d")
                                var gradient = ctx.createLinearGradient(100,0,100,200)
                                gradient.addColorStop(0, "#b12c19")
                                // setup the fill
                                ctx.fillStyle = gradient
                               // ctx.fillRect(50,50,100,100)
                                // begin a new path to draw
                                ctx.beginPath()
                                // top-left start point
                                ctx.moveTo(0,0)
                                // upper line
                                ctx.lineTo(60,0)
                                // right line
                                ctx.lineTo(0,60)
                                // bottom line
                                ctx.lineTo(0,0)
                                // left line through path closing
                                ctx.closePath()
                                // fill using fill style
                                ctx.fill()
                            }
                            Image {              
                                width: 24
                                fillMode: Image.PreserveAspectFit
                                source: focus ? "../assets/icons/heart_solid.svg" : "../assets/icons/heart_solid.svg"
                                asynchronous: true     
                                   
                                anchors {
                                    left: parent.left; 
                                    top: parent.top;
                                }
                                anchors.leftMargin: 6
                                anchors.topMargin: 6                          
                            }    
                            
                        }                        
                      }
                      
                    }               
                }
                                
            }
        
           
        }
        
        
    }  
    
     Footer{
      id: footer
    }   

}
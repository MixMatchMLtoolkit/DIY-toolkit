<?xml version="1.0" encoding="UTF-8"?>

<!-- <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected1"></xsl:param>

  <xsl:param name="tokenselected2"></xsl:param>

  <xsl:param name="label"></xsl:param>

  <xsl:param name="learning"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>

        <!-- <xsl:for-each select=""> -->

        <xsl:choose>

          <xsl:when test="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]/@exist = 'no'">
            <header>
              <div class="headerData">

                <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]">
                  <div class='leftheader'>
                    <div class='leftdiv'>

                      <img>

                        <xsl:attribute name="class">datacombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$label]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='datatoken token'><xsl:value-of select="datatype"/></h3>
                    </div>
                    <div class='rightdiv'>

                      <img>

                        <xsl:attribute name="class">abilitycombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$learning]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='abilitytoken token'><xsl:value-of select="ability"/></h3>

                    </div>
                  </div>
                  <div class="rightheader">
                    <h3 class='type combi'>Sorry!</h3>
                    <p class='description'>This is not a common combination and no examples currently exist on this website</p>
                    <xsl:if test="@NLP= 'yes'">
                      <p class= 'description'>The ML capability <span class='highlight combi'><xsl:value-of select="ability"/></span> works (only) with human language. So try combining it with audio or text!</p>
                    </xsl:if>
                  </div>
                </xsl:for-each>
              </div>
            </header>
          </xsl:when>

          <xsl:otherwise>
            <header>
              <div class="headerData">

                <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]">
                  <div class='leftheadercombi'>

                    <div class='leftdivcombi'>

                      <img>

                        <xsl:attribute name="class">datacombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$label]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='datatoken token'><xsl:value-of select="datatype"/></h3>
                      <!-- <p> <xsl:value-of select = "$label" /></p> <p> <xsl:value-of select = "../images/im[@value=$label]" /></p> -->

                    </div>
                    <div class='middivcombi'>

                      <img>

                        <xsl:attribute name="class">abilitycombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value=$learning]"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='abilitytoken token'><xsl:value-of select="ability"/></h3>
                      <!-- <p> <xsl:value-of select = "$learning" /></p> <p> <xsl:value-of select = "../images/im[@value=$learning]" /></p> -->

                    </div>
                    <!-- <div class='rightdivcombi'>
                      <img>

                        <xsl:attribute name="class">outputcombiimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value='combi']"/>
                        </xsl:attribute>
                      </img>
                      <h3 class='outputtoken token'><xsl:value-of select="outputtoken"/></h3>
                    </div> -->

                  </div>

                  <div class='rightheadercombi'>
                    <h3 class='type combi'><xsl:value-of select="name"/></h3>
                    <p class='descriptioncombi'>
                      <xsl:value-of select="description"/></p>
                    <p class='techterms'>
                      <i class="fa-solid fa-magnifying-glass fa-lg" style="color: #1E475E;">&#160;
                      </i>
                      <span class='bold'>Technical term(s):
                      </span>

                      <span><xsl:value-of select="techterm"/></span>
                    </p>

                    <div class='techterms'>

                      <i class="fa-solid fa-print fa-lg" style="color: #1E475E;">&#160;</i>
                      <span class='bold'>Output:&#160;
                      </span>
                      <img>

                        <xsl:attribute name="class">smalloutputimage
                        </xsl:attribute>

                        <xsl:attribute name="src"><xsl:value-of select="../images/im[@value='output']"/>
                        </xsl:attribute>
                      </img>
                      <span class="output"><xsl:value-of select="output" disable-output-escaping="yes"/></span>

                    </div>

                  </div>
                </xsl:for-each>
              </div>
            </header>
            <div class="headerData">
              <!-- <xsl:value-of select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]/examples/@exist"/> -->
              <xsl:choose>

                <xsl:when test="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]/examples/@exist = 'no'">
                  <div class='example'>

                  <h3 class='exampleHeader' style='text-align: center; '>There is no example (yet) for this combination</h3>

                </div>
                </xsl:when>

                <xsl:otherwise>
                  <div class='example'>

                    <xsl:for-each select="combinations/combi[datatoken=$tokenselected1 and abilitytoken=$tokenselected2]/examples/ex">

                      <div class='exImg'>
                        <img>

                          <xsl:attribute name="src">
                            <xsl:value-of select="eximage"/>
                          </xsl:attribute>

                          <xsl:attribute name="class">exampleImage
                          </xsl:attribute>
                        </img>
                      </div>
                      <div class='exText'>
                        <h3 class='exampleHeader'><xsl:value-of select="exname"/></h3>
                        <p>
                          <span class='bold'>Description:
                          </span><xsl:value-of select="exdescription"/></p>
                        <p>
                          <a href="{exlink/@xlink:href}" target="_blank">

                            <xsl:attribute name="onclick">sendlinkOOCSI("examplelink","<xsl:value-of select="exlink/@xlink:href"/>")
                            </xsl:attribute>
                            See example</a>
                        </p>
                        <p>
                          <a href="{diylink/@xlink:href}" target="_blank">

                            <xsl:attribute name="onclick">sendlinkOOCSI("diylink","<xsl:value-of select="diylink/@xlink:href"/>")
                            </xsl:attribute>
                            Train it yourself</a>
                        </p>
                      </div>
                    </xsl:for-each>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </xsl:otherwise>
        </xsl:choose>

      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>

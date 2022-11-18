<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected1"></xsl:param>

  <xsl:param name="tokenselected2"></xsl:param>

  <xsl:param name="token1"></xsl:param>
  <!-- supervised: sup or unsupervised unsup -->

  <xsl:param name="token2"></xsl:param>
  <!-- supervised: sup or unsupervised unsup -->

  <xsl:template match="/">
    <html>
      <body >
        <!-- <h3> Test</h3> <p>token1: <xsl:value-of select="$token1"/></p> <p>token2: <xsl:value-of select="$token2"/></p> <p> <xsl:value-of select="$tokenselected1"/></p> <p> <xsl:value-of select="$tokenselected2"/></p> -->
        <div class="compare">
          <div class="leftCompare">

            <xsl:for-each select="abilities/abilitytoken[token=$tokenselected1]">

              <xsl:choose>

                <xsl:when test="$token1 = 'supervised'">

                  <h3 class='typeC supervised'><xsl:value-of select="ability"/></h3>

                  <h4 class='supervised'>Supervised learning</h4>
                  <p class='descriptionAbilityCompare' id='descriptionL'>
                    <xsl:value-of select="description"/></p>
                    <div id="imageL">
                    <img>
                      <xsl:attribute name="class">illustrationAbilityC
                      </xsl:attribute>
                      <xsl:attribute name="src"><xsl:value-of select="imageHorizontal"/>
                      </xsl:attribute>
                    </img>
                  </div>
                  <p id='techtermL'>
                    <i class="fa-solid fa-magnifying-glass fa-lg supervised">&#160;
                    </i>
                    <span class='bold supervised'>Technical terms:
                    </span>
                    <span><xsl:value-of select="techterm"/></span>
                  </p>
                  <p class='bold supervised' id='examplesL'>Examples:</p>
                 <div id='examplesLeft'>

                   <p>
                     <!-- <span class='bold supervised'>Examples:
                     </span> -->
                     <ul>

                       <xsl:for-each select="examples/*">
                         <li><xsl:value-of select="@value"/></li>
                       </xsl:for-each>
                     </ul>
                   </p>
                 </div>
                  <p class='bold supervised pointer' onclick="showhideLeft()" >
                    <i class="fa fa-info-circle fa-lg supervised">&#160;
                  </i>
                  <span id="openCapLim" >Show capabilities and limitations </span></p>
                  <div id='fullspanCompareLeft' class='fullspan'>
                    <div class='leftdiv'>
                      <p>
                        <span class='bold supervised'>Capabilities:
                        </span>
                        <ul>

                          <xsl:for-each select="capabilities/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                        </ul>
                      </p>
                    </div>
                    <div class='rightdiv'>
                      <p>
                        <span class='bold supervised'>Limitations:
                        </span>
                        <ul>

                          <xsl:for-each select="limitations/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                        </ul>
                      </p>
                    </div>
                   </div>

                </xsl:when>

                <xsl:otherwise>
                  <h3 class='typeC unsupervised'><xsl:value-of select="ability"/></h3>

                  <h4 class='unsupervised'>Unupervised learning</h4>

                  <p class='descriptionAbilityCompare' id='descriptionL'>
                    <xsl:value-of select="description"/></p>
                    <div id="imageL">
                    <img>
                      <xsl:attribute name="class">illustrationAbilityC
                      </xsl:attribute>
                      <xsl:attribute name="src"><xsl:value-of select="imageHorizontal"/>
                      </xsl:attribute>
                    </img>
                  </div>
                  <p id='techtermL'>
                    <i class="fa-solid fa-magnifying-glass fa-lg unsupervised">&#160;
                    </i>
                    <span class='bold unsupervised'>Technical terms:
                    </span>
                    <span><xsl:value-of select="techterm"/></span>
                  </p>
                  <p class='bold unsupervised' id='examplesL'>Examples:</p>
                  <div id='examplesLeft'>

                    <p>
                      <!-- <span class='bold unsupervised'>Examples:
                      </span> -->
                      <ul>

                        <xsl:for-each select="examples/*">
                          <li><xsl:value-of select="@value"/></li>
                        </xsl:for-each>
                      </ul>
                    </p>
                  </div>
                  <p class='bold unsupervised pointer' onclick="showhideLeft()" >
                    <i class="fa fa-info-circle fa-lg unsupervised">&#160;
                    </i>
                    <span id="openCapLim" >Show capabilities and limitations </span></p>
                  <div id='fullspanCompareLeft' class='fullspan'>
                    <div class='leftdiv'>
                      <p>
                        <span class='bold unsupervised'>Capabilities:
                        </span>
                        <ul>

                          <xsl:for-each select="capabilities/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                        </ul>
                      </p>
                    </div>
                    <div class='rightdiv'>
                      <p>
                        <span class='bold unsupervised'>Limitations:
                        </span>
                        <ul>

                          <xsl:for-each select="limitations/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                        </ul>
                      </p>
                    </div>
                  </div>

                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>

          </div>
          <div class="rightCompare">
            <xsl:for-each select="abilities/abilitytoken[token=$tokenselected2]">

              <xsl:choose>

                <xsl:when test="$token2 = 'supervised'">
                  <h3 class='typeC supervised'><xsl:value-of select="ability"/></h3>

                  <h4 class='supervised'>Supervised learning</h4>
                  <p class='descriptionAbilityCompare' id='descriptionR'>
                    <xsl:value-of select="description"/></p>
                    <div id="imageR">
                    <img>
                      <xsl:attribute name="class">illustrationAbilityC
                      </xsl:attribute>
                      <xsl:attribute name="src"><xsl:value-of select="imageHorizontal"/>
                      </xsl:attribute>
                    </img>
                  </div>
                  <p id='techtermR'>
                    <i class="fa-solid fa-magnifying-glass fa-lg supervised">&#160;
                    </i>
                    <span class='bold supervised'>Technical terms:
                    </span>
                    <span><xsl:value-of select="techterm"/></span>
                  </p>
                  <p class='bold supervised' id='examplesR'>Examples:</p>
                  <div id='examplesRight'>

                    <p>
                      <!-- <span class='bold supervised'>Examples:
                      </span> -->
                      <ul>

                        <xsl:for-each select="examples/*">
                          <li><xsl:value-of select="@value"/></li>
                        </xsl:for-each>
                      </ul>
                    </p>
                  </div>
                  <p class='bold supervised pointer' onclick="showhideRight()" >
                    <i class="fa fa-info-circle fa-lg supervised">&#160;
                    </i>
                    <span id="openCapLimR" >Show capabilities and limitations </span></p>
                  <div id='fullspanCompareRight' class='fullspan'>
                    <div class='leftdiv'>
                      <p>
                        <span class='bold supervised'>Capabilities:
                        </span>
                        <ul>

                          <xsl:for-each select="capabilities/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                          <!-- <li>And much more...</li> -->
                        </ul>
                      </p>
                    </div>
                    <div class='rightdiv'>
                      <p>
                        <span class='bold supervised'>Limitations:
                        </span>
                        <ul>

                          <xsl:for-each select="limitations/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                        </ul>
                      </p>
                    </div>
                  </div>

                </xsl:when>

                <xsl:otherwise>
                  <h3 class='typeC unsupervised'><xsl:value-of select="ability"/></h3>

                  <h4 class='unsupervised'>Unsupervised learning</h4>
                  <p class='descriptionAbilityCompare' id='descriptionR'>
                    <xsl:value-of select="description"/></p>
                    <div id="imageR">
                    <img>
                      <xsl:attribute name="class">illustrationAbilityC
                      </xsl:attribute>
                      <xsl:attribute name="src"><xsl:value-of select="imageHorizontal"/>
                      </xsl:attribute>
                    </img>
                  </div>
                  <p id='techtermR'>
                    <i class="fa-solid fa-magnifying-glass fa-lg unsupervised">&#160;
                    </i>
                    <span class='bold unsupervised'>Technical terms:
                    </span>
                    <span><xsl:value-of select="techterm"/></span>
                  </p>
                  <p class='bold unsupervised' id='examplesR'>Examples:</p>
                  <div id='examplesRight'>

                    <p>
                      <!-- <span class='bold unsupervised'>Examples:
                      </span> -->
                      <ul>

                        <xsl:for-each select="examples/*">
                          <li><xsl:value-of select="@value"/></li>
                        </xsl:for-each>
                      </ul>
                    </p>
                  </div>
                  <p class='bold unsupervised pointer' onclick="showhideRight()" >
                    <i class="fa fa-info-circle fa-lg unsupervised">&#160;
                    </i>
                    <span id="openCapLimR" >Show capabilities and limitations </span></p>
                  <div id='fullspanCompareRight' class='fullspan'>
                    <div class='leftdiv'>
                      <p>
                        <span class='bold unsupervised'>Capabilities:
                        </span>
                        <ul>

                          <xsl:for-each select="capabilities/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                          <!-- <li>And much more...</li> -->
                        </ul>
                      </p>
                    </div>
                    <div class='rightdiv'>
                      <p>
                        <span class='bold unsupervised'>Limitations:
                        </span>
                        <ul>

                          <xsl:for-each select="limitations/*">
                            <li><xsl:value-of select="@value"/></li>
                          </xsl:for-each>
                        </ul>
                      </p>
                    </div>
                  </div>

                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </div>
        </div>
      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>

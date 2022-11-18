<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected"></xsl:param>

  <xsl:param name="abilityselected" select="abilities/abilitytoken[token=$tokenselected]/ability"></xsl:param>

  <xsl:template match="/">
    <html>
      <body id='replace'>
        <header>

          <div class="headerData">
            <div class='leftheader'>
              <img>

                <xsl:attribute name="class">reinforcementimage
                </xsl:attribute>

                <xsl:attribute name="src"><xsl:value-of select="abilities/reinforcement"/>
                </xsl:attribute>
              </img>
              <p class='overlaptextBig' style="top: 50px;   transform: translate(-30%);"><xsl:value-of select="abilities/abilitytoken[token=$tokenselected]/ability"/></p>
              <p class='overlaptextability' style="top: 130px;   transform: translate(-45%);">Reinforcement learning</p>
              <img>

                <xsl:attribute name="class">illustrationAbility
                </xsl:attribute>

                <xsl:attribute name="style">transform: translate(-5%); max-width: 220px;
                </xsl:attribute>

                <xsl:attribute name="src"><xsl:value-of select="abilities/abilitytoken[token=$tokenselected]/image"/>
                </xsl:attribute>
              </img>

            </div>

            <div class='rightheader'>

              <xsl:for-each select="abilities/abilitytoken[token=$tokenselected]">
                <h3 class='type reinforcement'><xsl:value-of select="ability"/></h3>
                <p class='descriptionAbility'>
                  <xsl:value-of select="description"/></p>
                <p>
                  <i class="fa-solid fa-magnifying-glass fa-lg reinforcement">&#160;
                  </i>
                  <span class='bold reinforcement'>Technical terms:
                  </span>
                  <span><xsl:value-of select="techterm"/></span>
                </p>
                <div>
                  <p>
                    <span class='bold reinforcement'>Examples:
                    </span>
                    <ul>

                      <xsl:for-each select="examples/*">
                        <li><xsl:value-of select="@value"/></li>
                      </xsl:for-each>
                    </ul>
                  </p>
                </div>

              <p class='bold reinforcement pointer' onclick="showhideLeft()">
                <i class="fa fa-info-circle fa-lg reinforcement">&#160;
                </i>
                <span id="openCapLim" >Show capabilities and limitations </span></p>
              <div id='fullspanCompareLeft' class='fullspan'>
                  <div class='leftdiv'>
                    <p>
                      <span class='bold reinforcement'>Capabilities:
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
                      <span class='bold reinforcement'>Limitations:
                      </span>
                      <ul>

                        <xsl:for-each select="limitations/*">
                          <li><xsl:value-of select="@value"/></li>
                        </xsl:for-each>
                        <!-- <li>ML is not perfect and will always make some errors</li> <li>The output of the model can be different even with the same input</li> -->
                      </ul>
                    </p>
                  </div>
                </div>

              </xsl:for-each>
            </div>

          </div>

        </header>

        <xsl:for-each select="abilities/abilitytoken[token=$tokenselected]">

          <!-- <header> <h2>ML ability: <xsl:value-of select="ability"/></h2> <p class='centerText'><xsl:value-of select="type"/></p> </header> -->
          <div class="centerBlock">
            <p>
              <span class='bold reinforcement'>Selection of pretrained models:
              </span>

            </p>
          </div>
        </xsl:for-each>
        <div>

          <table>
            <tr style="background-color:#82BE14">
              <th>Example</th>
              <th>Description</th>
              <!-- <th>Link</th> -->
            </tr>

            <xsl:for-each select="abilities/records/record[ability=$abilityselected]">

              <xsl:sort select="data"/>
              <tr>
                <td>
                  <a href="{url/@xlink:href}" target="_blank">

                    <xsl:attribute name="onclick">sendlinkOOCSI("modellink","<xsl:value-of select="mlmodel"/>")
                    </xsl:attribute>

                    <xsl:value-of select="mlmodel"/></a>
                </td>
                <td><xsl:value-of select="description"/></td>

              </tr>

            </xsl:for-each>
          </table>
        </div>
      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>

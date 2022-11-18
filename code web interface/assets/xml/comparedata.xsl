<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="tokenselected1"></xsl:param>

  <xsl:param name="tokenselected2"></xsl:param>

  <xsl:param name="token1"></xsl:param>
  <!-- labeled:ltoken or unlabeled:ultoken -->

  <xsl:param name="token2"></xsl:param>
  <!-- labeled:ltoken or unlabeled:ultoken -->

  <xsl:param name="dataselected1" select="data/datatoken[$token1=$tokenselected1]/dataname"></xsl:param>

  <xsl:param name="dataselected2" select="data/datatoken[$token2=$tokenselected2]/dataname"></xsl:param>

  <xsl:template match="/">
    <html>
      <body >
        <!-- <h3> Test</h3> <p>token1: <xsl:value-of select="$token1"/></p> <p>token2: <xsl:value-of select="$token2"/></p> <p> <xsl:value-of select="$tokenselected1"/></p> <p> <xsl:value-of select="$tokenselected2"/></p> -->

        <div class="compare">
          <div class="leftCompareData">

            <xsl:for-each select="data/datatoken[ltoken=$tokenselected1]">

              <xsl:choose>

                <xsl:when test="$token1 = 'ltoken'">
                  <h3 class='type labeled'><xsl:value-of select="dataname"/>
                    data</h3>
                  <p class="descriptionData" id="descriptionL"><xsl:value-of select="highlightLabeled  "/></p>

                  <img>

                    <xsl:attribute name="class">illustrationCompare
                    </xsl:attribute>

                    <xsl:attribute name="src"><xsl:value-of select="imageL"/>
                    </xsl:attribute>
                  </img>
                  <p>
                    <span class='bold labeled format'>Possible formats:
                    </span>
                    <span><xsl:value-of select="format"/></span>
                  </p>
                  <div class='pointer' onclick="showhideDataLeft()">
                    <p>
                      <i class="fa fa-info-circle fa-lg labeled">&#160;
                      </i>
                      <span class='bold labeled'>More information
                      </span>
                    </p>
                  </div>
                  <p class='description'>
                    <span id="descHiddenLeft">
                      <xsl:value-of select="descriptionLabeled"/>
                    </span>
                  </p>

                </xsl:when>

                <xsl:otherwise>
                  <h3 class='type unlabeled'><xsl:value-of select="dataname"/>
                    data</h3>
                  <p class="descriptionData" id="descriptionL"><xsl:value-of select="highlightUnlabeled  "/></p>
                  <img>

                    <xsl:attribute name="class">illustrationCompare
                    </xsl:attribute>

                    <xsl:attribute name="src"><xsl:value-of select="ulimage"/>
                    </xsl:attribute>
                  </img>
                  <!-- <p class='descriptionC' id='descriptionL'> <xsl:value-of select="descriptionUnlabeled"/></p> <p> -->
                  <p>
                    <span class='bold unlabeled format'>Possible formats:
                    </span>
                    <span><xsl:value-of select="format"/></span>
                  </p>
                  <div class='pointer' onclick="showhideDataLeft()">
                    <p>
                      <i class="fa fa-info-circle fa-lg unlabeled">&#160;
                      </i>
                      <span class='bold unlabeled'>More information
                      </span>
                    </p>
                  </div>
                  <p class='description'>
                    <span id="descHiddenLeft">
                      <xsl:value-of select="descriptionUnlabeled"/>
                    </span>
                  </p>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </div>
          <div class="rightCompareData">

            <xsl:for-each select="data/datatoken[ltoken=$tokenselected2]">

              <xsl:choose>

                <xsl:when test="$token2 = 'ltoken'">
                  <h3 class='type labeled'><xsl:value-of select="dataname"/>
                    data</h3>
                  <p class="descriptionData" id="descriptionR"><xsl:value-of select="highlightLabeled  "/></p>
                  <img>

                    <xsl:attribute name="class">illustration
                    </xsl:attribute>

                    <xsl:attribute name="src"><xsl:value-of select="imageL"/>
                    </xsl:attribute>
                  </img>
                  <!-- <h4 class='labeled'><xsl:value-of select="structure"/> labeled data</h4> <p class='descriptionC' id='descriptionR'> <xsl:value-of select="descriptionLabeled"/></p> -->
                  <p>
                    <span class='bold labeled format'>Possible formats:
                    </span>
                    <span><xsl:value-of select="format"/></span>
                  </p>
                  <div class='pointer' onclick="showhideDataRight()">
                    <p>
                      <i class="fa fa-info-circle fa-lg labeled">&#160;
                      </i>
                      <span class='bold labeled'>More information
                      </span>
                    </p>
                  </div>
                  <p class='description'>
                    <span id="descHiddenRight">
                      <xsl:value-of select="descriptionLabeled"/>
                    </span>
                  </p>
                </xsl:when>

                <xsl:otherwise>
                  <h3 class='type unlabeled'><xsl:value-of select="dataname"/>
                    data</h3>
                  <p class="descriptionData" id="descriptionR"><xsl:value-of select="highlightUnlabeled  "/></p>
                  <img>

                    <xsl:attribute name="class">illustration
                    </xsl:attribute>

                    <xsl:attribute name="src"><xsl:value-of select="ulimage"/>
                    </xsl:attribute>
                  </img>

                  <p>
                    <span class='bold unlabeled format'>Possible formats:
                    </span>
                    <span><xsl:value-of select="format"/></span>
                  </p>
                  <div class='pointer' onclick="showhideDataRight()">
                    <p>
                      <i class="fa fa-info-circle fa-lg unlabeled">&#160;
                      </i>
                      <span class='bold unlabeled'>More information
                      </span>
                    </p>
                  </div>
                  <p class='description'>
                    <span id="descHiddenRight">
                      <xsl:value-of select="descriptionUnlabeled"/>
                    </span>
                  </p>
                  <!-- <h4 class='unlabeled'><xsl:value-of select="structure"/> unlabeled data</h4> -->
                  <!-- <p class='descriptionC' id='descriptionR'>
                    <xsl:value-of select="descriptionUnlabeled"/></p> -->
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </div>
        </div>

        <!-- <header> <div class="headerData"> <div class='leftheader'> <img> <xsl:attribute name="class">labelimage </xsl:attribute> <xsl:attribute name="src"><xsl:value-of select="data/labeledimage"/> </xsl:attribute> </img> <img> <xsl:attribute
        name="class">dataimage </xsl:attribute> <xsl:attribute name="src"><xsl:value-of select="data/datatoken[ltoken=$tokenselected]/image"/> </xsl:attribute> </img> <p class='overlaptext'><xsl:value-of
        select="data/datatoken[ltoken=$tokenselected]/datatype"/></p> <p class='overlaptext2'>Labeled training dataset</p> </div> <div class='rightheader'> <xsl:for-each select="data/datatoken[ltoken=$tokenselected]"> <h3 class='type labeled'><xsl:value-of
        select="dataname"/> data</h3> <h4 class='labeled'><xsl:value-of select="structure"/> data</h4> <p class='descriptionC'> <xsl:value-of select="description"/></p> <p> <span class='bold labeled'>Possible formats: </span> <span><xsl:value-of
        select="format"/></span> </p> <img> <xsl:attribute name="class">illustration </xsl:attribute> <xsl:attribute name="src"><xsl:value-of select="image2"/> </xsl:attribute> </img> <p class='source'>Image source: <xsl:value-of select="source"/></p>
        </xsl:for-each> </div> </div> </header> <div class='centerBlock'> <p class="bold labeled">Selection of datasets:</p> <table> <tr style="background-color: #2D7F83;"> <th >Dataset</th> <th>Description</th> <th>Labeled</th> </tr> <xsl:for-each
        select="data/records/record[datatype=$dataselected and labeled='yes']"> <tr> <td> <a href="{url/@xlink:href}" target="_blank"> <xsl:attribute name="onclick">sendlinkOOCSI("datalink","<xsl:value-of select="dataset"/>") </xsl:attribute> <xsl:value-of
        select="dataset"/></a> </td> <td><xsl:value-of select="description"/></td> <td><xsl:value-of select="labeled"/></td> </tr> </xsl:for-each> </table> </div> -->

      </body>
      <footer></footer>
    </html>
  </xsl:template>

</xsl:stylesheet>

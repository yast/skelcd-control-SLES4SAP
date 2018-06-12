<!--
  Definition of the installation.SLES.xml -> installation.SLES4SAP.xml transformation.
  For now it simply copies all XML tags to the target file.
-->

<xsl:stylesheet version="1.0"
  xmlns:n="http://www.suse.com/1.0/yast2ns"
  xmlns:config="http://www.suse.com/1.0/configns"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.suse.com/1.0/yast2ns"
  exclude-result-prefixes="n"
>

<!--
Work around for the text domain
textdomain="control"
-->

<xsl:output method="xml" indent="yes"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- keep empty <![CDATA[]]>, see https://stackoverflow.com/a/1364900 -->
  <xsl:template match="n:optional_default_patterns">
      <xsl:element name="optional_default_patterns">
          <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
          <xsl:value-of select="text()" disable-output-escaping="yes"/>
          <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
      </xsl:element>
  </xsl:template>

  <xsl:template xml:space="preserve" match="n:system_role[n:id='minimal_role']">
        <system_role>
        <id>sles4sap_role</id>

        <!-- the rest is overlaid over the feature sections and values. -->
        <partitioning>
           <proposal>
             <lvm config:type="boolean">true</lvm>
             <encrypt config:type="boolean">false</encrypt>
             <windows_delete_mode>all</windows_delete_mode>
             <linux_delete_mode>all</linux_delete_mode>
             <other_delete_mode>all</other_delete_mode>
             <lvm_vg_strategy>use_needed</lvm_vg_strategy>
           </proposal>

           <volumes config:type="list">
             <!-- The root filesystem -->
             <volume>
               <mount_point>/</mount_point>
               <!-- Enforce Btrfs for root by not offering any other option -->
               <fs_type>btrfs</fs_type>
               <desired_size>60GiB</desired_size>
               <min_size>40GiB</min_size>
               <max_size>80GiB</max_size>
               <!-- Always use snapshots, no matter what -->
               <snapshots config:type="boolean">true</snapshots>
               <snapshots_configurable config:type="boolean">false</snapshots_configurable>

               <btrfs_default_subvolume>@</btrfs_default_subvolume>
               <subvolumes config:type="list">
                 <subvolume>
             	<path>home</path>
                 </subvolume>
                 <subvolume>
             	<path>opt</path>
                 </subvolume>
                 <subvolume>
             	<path>root</path>
                 </subvolume>
                 <subvolume>
             	<path>srv</path>
                 </subvolume>
                 <subvolume>
             	<path>tmp</path>
                 </subvolume>
                 <subvolume>
             	<path>usr/local</path>
                 </subvolume>
                 <!-- unified var subvolume - https://lists.opensuse.org/opensuse-packaging/2017-11/msg00017.html -->
                 <subvolume>
             	<path>var</path>
             	<copy_on_write config:type="boolean">false</copy_on_write>
                 </subvolume>
                 <!-- architecture specific subvolumes -->

                 <subvolume>
             	<path>boot/grub2/i386-pc</path>
             	<archs>i386,x86_64</archs>
                 </subvolume>
                 <subvolume>
             	<path>boot/grub2/x86_64-efi</path>
             	<archs>x86_64</archs>
                 </subvolume>
                 <subvolume>
             	<path>boot/grub2/powerpc-ieee1275</path>
             	<archs>ppc,!board_powernv</archs>
                 </subvolume>
                 <subvolume>
             	<path>boot/grub2/x86_64-efi</path>
             	<archs>x86_64</archs>
                 </subvolume>
                 <subvolume>
             	<path>boot/grub2/s390x-emu</path>
             	<archs>s390</archs>
                 </subvolume>
                 <subvolume>
             	<path>boot/grub2/arm64-efi</path>
             	<archs>aarch64</archs>
                 </subvolume>
               </subvolumes>
             </volume>

             <!-- The swap volume -->
             <volume>
               <mount_point>swap</mount_point>
               <fs_type>swap</fs_type>
               <desired_size>2GiB</desired_size>
               <min_size>2GiB</min_size>
               <max_size>2GiB</max_size>
             </volume>

             <!--
               No home filesystem, so the option of a separate home is not even
               offered to the user.
               On the other hand, a separate data volume (optional or mandatory) could
               be defined.
             -->

           </volumes>
        </partitioning>
        <additional_dialogs>inst_sap-start</additional_dialogs>
        <software>
          <default_patterns>base gnome_basic sap_server</default_patterns>
        </software>
        </system_role>
      <xsl:copy>
        <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>

  <xsl:template xml:space="preserve" match="n:minimal_role">
      <sles4sap_role>
          <!-- TRANSLATORS: a label for a system role -->
          <label>SLES for SAP Applications</label>
      </sles4sap_role>
      <sles4sap_role_description>
          <label>• Ideal if you want to run an SAP Application
• RDP and SAP Installation Wizard option available</label>
      </sles4sap_role_description>
      <xsl:copy>
        <xsl:apply-templates/>
      </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

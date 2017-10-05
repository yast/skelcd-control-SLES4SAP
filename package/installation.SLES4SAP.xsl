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

  <xsl:template xml:space="preserve" match="n:partitioning"><partitioning>
      <proposal>
        <lvm config:type="boolean">true</lvm>
        <encrypt config:type="boolean">false</encrypt>
        <windows_delete_mode>all</windows_delete_mode>
        <linux_delete_mode>ondemand</linux_delete_mode>
        <other_delete_mode>ondemand</other_delete_mode>
        <lvm_vg_strategy>use_needed</lvm_vg_strategy>
      </proposal>
    
      <volumes config:type="list">
        <!-- The root filesystem -->
        <volume>
          <mount_point>/</mount_point>
          <!-- Enforce Btrfs for root by not offering any other option -->
          <fstypes>btrfs</fstypes>
          <desired_size>60GiB</desired_size>
          <min_size>40GiB</min_size>
          <max_size>80GiB</max_size>
          <weight>50</weight>
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
    		<path>srv</path>
    	    </subvolume>
    	    <subvolume>
    		<path>tmp</path>
    	    </subvolume>
    	    <subvolume>
    		<path>usr/local</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/cache</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/crash</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/lib/libvirt/images</path>
    		<copy_on_write config:type="boolean">false</copy_on_write>
    	    </subvolume>
    	    <subvolume>
    		<path>var/lib/machines</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/lib/mailman</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/lib/mariadb</path>
    		<copy_on_write config:type="boolean">false</copy_on_write>
    	    </subvolume>
    	    <subvolume>
    		<path>var/lib/mysql</path>
    		<copy_on_write config:type="boolean">false</copy_on_write>
    	    </subvolume>
    	    <subvolume>
    		<path>var/lib/named</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/lib/pgsql</path>
    		<copy_on_write config:type="boolean">false</copy_on_write>
    	    </subvolume>
    	    <subvolume>
    		<path>var/log</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/opt</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/spool</path>
    	    </subvolume>
    	    <subvolume>
    		<path>var/tmp</path>
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
          </subvolumes>
        </volume>
    
        <!-- The swap volume -->
        <volume>
          <mount_point>swap</mount_point>
          <fstype>swap</fstype>
          <desired_size>6GiB</desired_size>
          <min_size>4GiB</min_size>
          <max_size>10GiB</max_size>
          <weight>50</weight>
        </volume>
    
        <!--
          No home filesystem, so the option of a separate home is not even
          offered to the user.
          On the other hand, a separate data volume (optional or mandatory) could
          be defined.
        -->
    
      </volumes>
    </partitioning></xsl:template>


  <xsl:template xml:space="preserve" match="n:module[n:name='user_first']"><module>
                   <label>Installation Mode</label>
                   <name>sap-start</name>
                   <enable_back>yes</enable_back>
                   <enable_next>yes</enable_next>
         </module></xsl:template>

  <xsl:template xml:space="preserve" match="n:workflow[n:stage='continue' and n:mode='autoinstallation']">
	  <xsl:copy>
	    <xsl:apply-templates/>
	  </xsl:copy><workflow>
            <defaults>
                <archs>all</archs>
            </defaults>
            <label>Preparation</label>
            <mode>installation</mode>
            <stage>continue</stage>
            <modules config:type="list">
                <module>
                    <label>SAP Setup</label>
                    <name>sap</name>
                </module>
            </modules>
        </workflow></xsl:template>
</xsl:stylesheet>

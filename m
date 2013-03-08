From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Sat, 09 Mar 2013 02:17:13 +0800
Message-ID: <513A2B29.8090705@redhat.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>  <5135BD66.1030005@redhat.com> <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362755479.15011.238.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 03/08/2013 11:11 PM, Matt Fleming wrote:
> +			/*
> +			 * Some firmware implementations return the
> +			 * same variable name on consecutive calls to
> +			 * get_next_variable(). Terminate the loop
> +			 * immediately as there is no guarantee that
> +			 * we'll ever see a different variable name,
> +			 * and may end up looping here forever.
> +			 */
> +			if (!efi_guidcmp(prev_guid, vendor_guid) &&
> +			     !memcmp(prev_name, variable_name, variable_name_size)) {
> +				printk(KERN_WARNING "efivars: duplicate variable name.\n");
> +				status = EFI_NOT_FOUND;
> +				break;
> +			}

Comparing with the immediately previous one won't detect larger loop
like how The IBM x3100 M4 in question was looping as below.

(There is some log loss; probably too much data for serial.)
[    9.783119] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[    9.852017] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[    9.856520] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0003-d665f20a-f2b7-485e-a321-542a196f40c7'
[    9.860840] sysfs: cannot create duplicate filename '/firmware/efi/vars/AcpiGlobalVariable-c020489e-6db2-4ef2-9aa5-ca06fc11d36a'
[    9.865735] sysfs: cannot create duplicate filename '/firmware/efi/vars/NodalSetup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[    9.871157] sysfs: cannot create duplicate filename '/firmware/efi/vars/DIMMStatusVariable-c020489e-6db2-4fe2-a2b1-ca05cca1336a'
[    9.876473] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0007-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   11.541964] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   11.556008] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[   11.560022] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   11.564583] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0003-d665f20a-f2b7-485e-a321-542a196f40c7'
[   11.568977] sysfs: cannot create duplicate filename '/firmware/efi/vars/AcpiGlobalVariable-c020489e-6db2-4ef2-9aa5-ca06fc11d36a'
[   11.573929] sysfs: cannot create duplicate filename '/firmware/efi/vars/NodalSetup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[   13.278655] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   13.292703] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[   13.296716] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   13.301283] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0003-d665f20a-f2b7-485e-a321-542a196f40c7'
[   13.305669] sysfs: cannot create duplicate filename '/firmware/efi/vars/AcpiGlobalVariable-c020489e-6db2-4ef2-9aa5-ca06fc11d36a'
[   13.310628] sysfs: cannot create duplicate filename '/firmware/efi/vars/NodalSetup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[   13.316108] sysfs: cannot create duplicate filename '/firmware/efi/vars/DIMMStatusVariable-c020489e-6db2-4fe2-a2b1-ca05cca1336a'
[   15.004171] sysfs: cannot create duplicate filename '/firmware/efi/vars/BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   15.017737] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   15.031713] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[   15.035730] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   15.040355] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0003-d665f20a-f2b7-485e-a321-542a196f40c7'
[   15.044743] sysfs: cannot create duplicate filename '/firmware/efi/vars/AcpiGlobalVariable-c020489e-6db2-4ef2-9aa5-ca06fc11d36a'
[   15.049700] sysfs: cannot create duplicate filename '/firmware/efi/vars/NodalSetup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
[   16.729287] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0001-d665f20a-f2b7-485e-a321-542a196f40c7'
[   16.742919] sysfs: cannot create duplicate filename '/firmware/efi/vars/BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   16.756550] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   16.770526] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[   16.774532] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   16.779093] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0003-d665f20a-f2b7-485e-a321-542a196f40c7'
[   16.783542] sysfs: cannot create duplicate filename '/firmware/efi/vars/AcpiGlobalVariable-c020489e-6db2-4ef2-9aa5-ca06fc11d36a'
[   18.467922] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0001-d665f20a-f2b7-485e-a321-542a196f40c7'
[   18.481615] sysfs: cannot create duplicate filename '/firmware/efi/vars/BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   18.495194] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   18.509242] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[   18.513252] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   18.517806] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0003-d665f20a-f2b7-485e-a321-542a196f40c7'
[   20.193306] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   20.206649] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0001-d665f20a-f2b7-485e-a321-542a196f40c7'
[   20.220341] sysfs: cannot create duplicate filename '/firmware/efi/vars/BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   20.233916] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   20.247957] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[   20.251970] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   21.918960] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0004-d665f20a-f2b7-485e-a321-542a196f40c7'
[   21.931944] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   21.945286] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0001-d665f20a-f2b7-485e-a321-542a196f40c7'
[   21.958984] sysfs: cannot create duplicate filename '/firmware/efi/vars/BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   21.972559] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   21.986608] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
[   23.644961] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0004-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   23.657688] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0004-d665f20a-f2b7-485e-a321-542a196f40c7'
[   23.670724] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   23.684062] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0001-d665f20a-f2b7-485e-a321-542a196f40c7'
[   23.697692] sysfs: cannot create duplicate filename '/firmware/efi/vars/BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   23.711324] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBootValidate-d665f20a-f2b7-485e-a321-542a196f40c7'
[   25.370482] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0006-d665f20a-f2b7-485e-a321-542a196f40c7'
[   25.382749] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0004-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   25.395419] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0004-d665f20a-f2b7-485e-a321-542a196f40c7'
[   25.408343] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   25.421625] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0001-d665f20a-f2b7-485e-a321-542a196f40c7'
[   25.435192] sysfs: cannot create duplicate filename '/firmware/efi/vars/BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   27.087790] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0006-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   27.099845] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0006-d665f20a-f2b7-485e-a321-542a196f40c7'
[   27.112118] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0004-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   27.124788] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0004-d665f20a-f2b7-485e-a321-542a196f40c7'
[   27.137702] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   27.150990] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0001-d665f20a-f2b7-485e-a321-542a196f40c7'
[   28.805316] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0005-d665f20a-f2b7-485e-a321-542a196f40c7'
[   28.816944] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0006-8be4df61-93ca-11d2-aa0d-00e098032b8c'
[   28.829010] sysfs: cannot create duplicate filename '/firmware/efi/vars/CFGBoot0006-d665f20a-f2b7-485e-a321-542a196f40c7'
[   28.841278] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0004-8be4df61-93ca-11d2-aa0d-00e098032b8c'

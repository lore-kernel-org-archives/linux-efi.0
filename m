From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 0/4 v3] kexec-tools: efi runtime support
Date: Thu, 21 Nov 2013 14:40:43 +0800
Message-ID: <20131121064043.969000753@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

This is the v3 patchset for adding efi runtime support on kexec kernel
kernel patches was sent a while ago, not yet updated in archive. 

in kexec-tools, this patchset will do below:
1. retrieve efi_info from sysfs boot_params, and fill the
x86 setup header. If kernel does not export sysfs boot_params,
still try to find them in debugfs.

2. collect data efi runtime needed:
/sys/firmware/efi/systab: smbios
/sys/firmware/efi/fw_vendor
/sys/firmware/efi/runtime
/sys/firmware/efi/config_table

/sys/firmware/efi/runtime-map/*, the phys-virt mappings in 1st kernel

3. assemble setup_data based on data get in 2) then pass it to 2nd kernel

Tested on OVMF, dell laptop, lenovo laptop and HP workstation

TODO: add functions for easily adding setup_data, arrange them as link list
because we probably will add e820 memory ranges as setup_data as well.
I do not prefer to bloat this patchset anymore, so I'd likt to address this
issue after the efi runtime issue finished unless people request.

V2 changelog:
Address comments from
Simon:
  coding style, fixed a mem leak
HPA:
  use type uint64_t instead of __uint64_t
mjg:
  do not cause regression for loading old kernel
  use xloadflags to check the bzImage support for efi.
  in case old kernel, do not pass efi_info and setup_data
  for new kernel, do not pass acpi_rsdp
Vivek:
  suggest to export a value in bzImage probe for efi support
  so it can be used to check if we should pass acpi_rsdp.

V3 changelog:
01/04: new patch of a building fix
try sysfs firstly for boot params
add checking of efi memory range description version, bail out if it's not 1
error handling improvement and some cleanups

--
Thanks
Dave

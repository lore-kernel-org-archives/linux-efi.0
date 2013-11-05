From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 0/3 v2] kexec-tools: efi runtime support
Date: Tue, 05 Nov 2013 16:29:47 +0800
Message-ID: <20131105082947.500512312@dhcp-16-126.nay.redhat.com>
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
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This patchset is for adding efi runtime support on kexec kernel
kernel patches see below thread:
http://thread.gmane.org/gmane.linux.kernel.efi/2491

in kexec-tools, this patchset will do below:
1. retrieve efi_info from debugfs boot_params, and fill the
x86 setup header

2. collect data efi runtime needed:
/sys/firmware/efi/systab: fw_vendor, runtime, config_tables and smbios
/sys/firmware/efi/efi-runtime-map/*, the phys-virt mappings in 1st kernel

3. assemble setup_data based on data get in 2) then pass it to 2nd kernel

Tested on OVMF, dell laptop, lenovo laptop and HP workstation

Please help to review

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

--
Thanks
dave

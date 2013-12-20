From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/4] kexec-tools: efi runtime support on kexec kernel
Date: Fri, 20 Dec 2013 18:05:43 +0800
Message-ID: <1387533947-18210-1-git-send-email-dyoung@redhat.com>
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

changelog v3->v4:
update efi_info memmap to the saved runtime map instead of use 1st kernel
untouched memmap.

Tested on OVMF, dell laptop, lenovo laptop and HP workstation

Dave Young (4):
  build fix: include x86-linux.h in x86-linux-setup.h
  Add function get_bootparam
  Add efi_info in x86 setup header
  Passing efi related data via setup_data

 include/x86/x86-linux.h             |   3 +-
 kexec/arch/i386/crashdump-x86.c     |   4 +-
 kexec/arch/i386/x86-linux-setup.c   | 246 ++++++++++++++++++++++++++++++++++--
 kexec/arch/i386/x86-linux-setup.h   |   2 +
 kexec/arch/x86_64/kexec-bzImage64.c |   6 +
 5 files changed, 248 insertions(+), 13 deletions(-)

-- 
1.8.3.1

From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V16 08/11] efi: print unrecognized CPER section
Date: Tue, 16 May 2017 16:29:27 +0200
Message-ID: <20170516142927.guxwc3gdgpqshpks@pd.tnic>
References: <1494883680-25551-1-git-send-email-tbaicar@codeaurora.org>
 <1494883680-25551-9-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494883680-25551-9-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, May 15, 2017 at 03:27:57PM -0600, Tyler Baicar wrote:
> UEFI spec allows for non-standard section in Common Platform Error
> Record. This is defined in section N.2.3 of UEFI version 2.5.
> 
> Currently if the CPER section's type (UUID) does not match with
> one of the section types that the kernel knows how to parse, the
> section is skipped. Therefore, user is not able to see
> such CPER data, for instance, error record of non-standard section.
> 
> This change prints out the raw data in hex in the dmesg buffer so
> that non-standard sections are reported to the user. Non-standard
> section type errors should be reported to the user because these
> can include errors which are vendor specific. The data length is
> taken from Error Data length field of Generic Error Data Entry.
> 
> The following is a sample output from dmesg:
> [  140.739180] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
> [  140.739182] {1}[Hardware Error]: It has been corrected by h/w and requires no further action
> [  140.739191] {1}[Hardware Error]: event severity: corrected
> [  140.739196] {1}[Hardware Error]:  time: precise 2017-03-15 20:37:35
> [  140.739197] {1}[Hardware Error]:  Error 0, type: corrected
> [  140.739203] {1}[Hardware Error]:   section type: unknown, d2e2621c-f936-468d-0d84-15a4ed015c8b
> [  140.739205] {1}[Hardware Error]:   section length: 0x238
> [  140.739210] {1}[Hardware Error]:   00000000: 4d415201 4d492031 453a4d45 435f4343  .RAM1 IMEM:ECC_C
> [  140.739214] {1}[Hardware Error]:   00000010: 53515f45 44525f42 00000000 00000000  E_QSB_RD........
> [  140.739217] {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000  ................
> [  140.739220] {1}[Hardware Error]:   00000030: 00000000 00000000 01010000 01010000  ................
> [  140.739223] {1}[Hardware Error]:   00000040: 00000000 00000000 00000005 00000000  ................
> [  140.739226] {1}[Hardware Error]:   00000050: 01010000 00000000 00000001 00dddd00  ................

Let me repeat myself from the last time:

"Kill all those prefixes:

" Hardware error from APEI Generic Hardware Error Source: 2
  It has been corrected by h/w and requires no further action
  event severity: corrected
   time: precise 2017-03-15 20:37:35
   Error 0, type: corrected
    section type: unknown, d2e2621c-f936-468d-0d84-15a4ed015c8b
    section length: 568 (0x238)
    00000000: 4d415201 4d492031 453a4d45 435f4343  .RAM1 IMEM:ECC_C
    00000010: 53515f45 44525f42 00000000 00000000  E_QSB_RD........
    00000020: 00000000 00000000 00000000 00000000  ................
    00000030: 00000000 00000000 01010000 01010000  ................
    00000040: 00000000 00000000 00000005 00000000  ................
    00000050: 01010000 00000000 00000001 00dddd00  ................
"

to the important info only."

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.

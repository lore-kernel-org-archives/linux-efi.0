From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 24 Apr 2018 17:09:52 +0200
Message-ID: <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180423211143.GZ14440@wotan.suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@lin>
List-Id: linux-efi@vger.kernel.org

Hi,

On 23-04-18 23:11, Luis R. Rodriguez wrote:
> Hans, please see use of READING_FIRMWARE_PREALLOC_BUFFER, we'll need a new ID
> and security for this type of request so IMA can reject it if the policy is
> configured for it.

Hmm, interesting, actually it seems like the whole existence
of READING_FIRMWARE_PREALLOC_BUFFER is a mistake, the IMA
framework really does not care if we are loading the firmware
into memory allocated by the firmware-loader code, or into
memory allocated by the device-driver requesting the firmware.

As such the current IMA code (from v4.17-rc2) actually does
not handle READING_FIRMWARE_PREALLOC_BUFFER at all, here
are bits of code from: security/integrity/ima/ima_main.c:

static int read_idmap[READING_MAX_ID] = {
         [READING_FIRMWARE] = FIRMWARE_CHECK,
         [READING_MODULE] = MODULE_CHECK,
         [READING_KEXEC_IMAGE] = KEXEC_KERNEL_CHECK,
         [READING_KEXEC_INITRAMFS] = KEXEC_INITRAMFS_CHECK,
         [READING_POLICY] = POLICY_CHECK
};

int ima_post_read_file(struct file *file, void *buf, loff_t size,
	...
         if (!file && read_id == READING_FIRMWARE) {
                 if ((ima_appraise & IMA_APPRAISE_FIRMWARE) &&
                     (ima_appraise & IMA_APPRAISE_ENFORCE))
                         return -EACCES; /* INTEGRITY_UNKNOWN */
                 return 0;
         }

Which show that the IMA code is not handling
READING_FIRMWARE_PREALLOC_BUFFER as it should (I believe it
should handle it the same as READING_FIRMWARE).

Now we could fix that, but the only user of
READING_FIRMWARE_PREALLOC_BUFFER is the code which originally
introduced it:

https://patchwork.kernel.org/patch/9162011/

So I believe it might be better to instead replace it
with just READING_FIRMWARE and find another way to tell
kernel_read_file() that there is a pre-allocated buffer,
perhaps the easiest way there is that  *buf must be
NULL when the caller wants kernel_read_file() to
vmalloc the mem. This would of course require auditing
all callers that the buf which the pass in is initialized
to NULL.

Either way adding a third READING_FIRMWARE_FOO to the
kernel_read_file_id enum seems like a bad idea, from
the IMA pov firmware is firmware.

What this whole exercise has shown me though is that
I need to call security_kernel_post_read_file() when
loading EFI embedded firmware. I will add a call to
security_kernel_post_read_file() for v4 of the patch-set.

> Please Cc Kees in future patches.

Will do.

Regards,

Hans

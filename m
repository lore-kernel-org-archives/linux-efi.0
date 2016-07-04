From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/7] efi: Document #define FOO_PROTOCOL_GUID layout
Date: Mon, 4 Jul 2016 14:17:31 +0100
Message-ID: <20160704131731.GL8415@codeblueprint.co.uk>
References: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
 <1466839230-12781-3-git-send-email-matt@codeblueprint.co.uk>
 <20160627104920.GA9099@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160627104920.GA9099@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 27 Jun, at 12:49:20PM, Ingo Molnar wrote:
 
> The other weirdness is the misalignment of the '0xe' portion here:
> 
> #define LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID	EFI_GUID(0xe03fc20a, 0x85dc, 0x406e,  0xb9, 0xe, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
> #define LINUX_EFI_LOADER_ENTRY_GUID		EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
> 
> Am I correct that LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID is purely Linux kernel 
> internal, and that we can write 0xe as 0x0e?
 
Yep, you're correct.

> The patch below implements this organization of the GUIDs on top of your patch.
> 
> Also note that it should still be easy to line up these lines with the spec, as I 
> left an extra space before the 'byte' portion of the table, so the table is 
> separated into two areas visually.

Looks fine to me, and so did Joe's checkpatch patch.

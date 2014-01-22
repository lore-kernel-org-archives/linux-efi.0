From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 4/6] arm64: add EFI stub
Date: Wed, 22 Jan 2014 18:04:43 +0000
Message-ID: <20140122180443.GF8065@arm.com>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
 <1389392950-22457-5-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1389392950-22457-5-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>, "matt.fleming@intel.com" <matt.fleming@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, "roy.franz@linaro.org" <roy.franz@linaro.org>, "patches@linaro.org" <patches@linaro.org>, Grant Likely <grant.likely@secretlab.ca>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 10, 2014 at 10:29:08PM +0000, Mark Salter wrote:
> +ENTRY(efi_stub_entry)
> +       stp     x29, x30, [sp, #-32]!
> +
> +       /*
> +        * Call efi_entry to do the real work.
> +        * x0 and x1 are already set up by firmware. Current runtime
> +        * address of image is calculated and passed via *image_addr.
> +        *
> +        * unsigned long efi_entry(void *handle,
> +        *                         efi_system_table_t *sys_table,
> +        *                         unsigned long *image_addr) ;
> +        */
> +       adrp    x8, _text
> +        add    x8, x8, #:lo12:_text

Possibly some minor whitespace corruption (or it's our email server).

-- 
Catalin

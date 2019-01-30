From: Tyler Baicar <baicar.tyler@gmail.com>
Subject: Re: [PATCH v2 0/2] Fix crash in cper_estatus_check()
Date: Wed, 30 Jan 2019 11:03:05 -0500
Message-ID: <CABo9ajD5B2D=DoxD+-mm9EkCfBXUyB9Zb7h7B8aUoazcb-tCSA@mail.gmail.com>
References: <20190128100424.30278-1-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128100424.30278-1-ross.lagerwall@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 28, 2019 at 5:06 AM Ross Lagerwall
<ross.lagerwall@citrix.com> wrote:
>
> v2 changes:
> - Address Boris's comments.
>
> ---
>
> I recently encountered a crash in cper_estatus_check() when called by
> bert_init(). Patches follow to fix the problem. Note that I cannot fully
> test the patches since the hardware error record on that machine has
> been cleared.
>
> Ross Lagerwall (2):
>   acpi/apei: Fix possible out-of-bounds access to BERT region
>   efi/cper: Fix possible out-of-bounds access

For both patches:

Tested-by: Tyler Baicar <baicar.tyler@gmail.com>

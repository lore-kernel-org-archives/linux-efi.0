From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 0/2 RESEND v7] add reserved e820 ranges to the kdump
 kernel e820 table
Date: Mon, 26 Nov 2018 09:44:46 -0800
Message-ID: <d457ed46-d983-20b2-ad7f-9eaa6d98f2bf@intel.com>
References: <20181124051223.19994-1-lijiang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181124051223.19994-1-lijiang@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Lianbo Jiang <lijiang@redhat.com>, linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-ia64@vger.kernel.org, linux-efi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, akpm@linux-foundation.org, dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, ard.biesheuvel@linaro.org, tony.luck@intel.com, fenghua.yu@intel.com, dyoung@redhat.com, bhe@redhat.com
List-Id: linux-efi@vger.kernel.org

On 11/23/18 9:12 PM, Lianbo Jiang wrote:
> These patches add the new I/O resource descriptor 'IORES_DESC_RESERVED'
> for the iomem resources search interfaces, and in order to make it still
> work after the new descriptor is added, these codes originally related
> to 'IORES_DESC_NONE' have been updated.

I'm having a really hard time figuring out what problem these patches solve.

What end-user visible behavior does this set change?

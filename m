From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 1/2 RESEND v7] resource: add the new I/O resource
 descriptor 'IORES_DESC_RESERVED'
Date: Tue, 27 Nov 2018 07:34:16 -0800
Message-ID: <703ce20d-be09-9b8d-d457-5b002a50dff7@intel.com>
References: <20181124051223.19994-1-lijiang@redhat.com>
 <20181124051223.19994-2-lijiang@redhat.com>
 <ae405fe9-94fd-3fb7-decd-c7821cf95b7d@intel.com>
 <460c5552-a48e-3523-275a-7f94d0f08f9b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <460c5552-a48e-3523-275a-7f94d0f08f9b@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: lijiang <lijiang@redhat.com>, linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-ia64@vger.kernel.org, linux-efi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, akpm@linux-foundation.org, dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, ard.biesheuvel@linaro.org, tony.luck@intel.com, fenghua.yu@intel.com, dyoung@redhat.com, bhe@redhat.com
List-Id: linux-efi@vger.kernel.org

On 11/27/18 2:04 AM, lijiang wrote:
> What happens if we don't modify this functions
> __ioremap_check_desc_other()? -When SEV is active, it might map these
> reserved regions with the encryption mask. That is incorrect. 

This is missing another sentence or two to "connect the dots".

SEV uses data that comes from the e820 table to tell whether or not the
memory should be encrypted?  If we don't reflect these reserved areas in
the e820 table, the SEV code will set up encrypted mappings for device
memory, for instance?

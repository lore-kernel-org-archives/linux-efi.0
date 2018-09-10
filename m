From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V5 0/2] Add efi page fault handler to recover from page
Date: Mon, 10 Sep 2018 19:47:15 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485BAE95@ORSMSX114.amr.corp.intel.com>
References: <1536607945-22018-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536607945-22018-1-git-send-email-sai.praneeth.prakhya@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Cc: Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Hi All,

> Changes from V4 to V5:
> ----------------------
> 1. Drop config option that enables efi page fault handler, instead make
>    it default.
> 2. Call schedule() in an infinite loop to account for spurious wake ups.
> 3. Introduce "NONE" as an efi runtime service function identifier so that
>    it could be used in efi_recover_from_page_fault() to check if the page
>    fault was indeed triggered by an efi runtime service.

Please note that apart from dropping the config knob and accounting for 
spurious wake ups, I have added a third change.

I realized that when kernel command line option efi=old_map is passed, the efi 
page fault handler in V4 wouldn't work because, it checks for efi_mm.

In the efi page fault handler, I have also added an explicit check for x86_64 because 
AFAIK, x86_32 bit machines do not suffer from this problem (Boris, please correct me if I am wrong).
Also, I was unable to trigger page faults with buggy OVMF for x86_32.

Just wanted to state the third change explicitly here so that it doesn't escape reviewers eyes.

Regards,
Sai

From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 05/32] x86/CPU/AMD: Handle SME reduction in physical
 address size
Date: Thu, 20 Apr 2017 20:52:37 +0200
Message-ID: <20170420185237.g5toqhgbemhcfu36@pd.tnic>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211711.10190.30861.stgit@tlendack-t1.amdoffice.net>
 <20170420165922.j2inlwbchrs6senw@pd.tnic>
 <aaa52e93-5875-6033-e72f-8fc3de43ca3a@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aaa52e93-5875-6033-e72f-8fc3de43ca3a@amd.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 20, 2017 at 12:29:20PM -0500, Tom Lendacky wrote:
> Hmmm... and actually if cpu_has(X86_FEATURE_SME) is true then it's a
> given that extended_cpuid_level >= 0x8000001f.  So this can be
> simplified to just:
> 
> 	if (cpu_has(c, X86_FEATURE_SME)) {
> 		... the rest of your suggestion (minus cpu_has()) ...

Cool, even better! :)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.

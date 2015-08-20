From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 04/16] x86/efi: Generating random number in EFI stub
Date: Thu, 20 Aug 2015 15:12:21 +0100
Message-ID: <20150820141221.GC2567@codeblueprint.co.uk>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-5-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439273796-25359-5-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Aug, at 02:16:24PM, Lee, Chun-Yi wrote:
> This patch adds the codes for generating random number array as the
> HMAC key that will used by later EFI stub codes.
> 
> The original codes in efi_random copied from aslr and add the codes
> to accept input entropy and EFI debugging. In later patch will add
> the codes to get random number by EFI protocol. The separate codes
> can avoid impacting aslr function.
 
Is there some way we can share the code between aslr and the EFI boot
stub? People may not review both files when making changes and so bug
fixes to one might not appear in the other.

-- 
Matt Fleming, Intel Open Source Technology Center

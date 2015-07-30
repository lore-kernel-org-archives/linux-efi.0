From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [RFC PATCH 02/16] x86/efi: Add get and set variable to EFI
 services pointer table
Date: Thu, 30 Jul 2015 16:19:58 +0100
Message-ID: <1438269598.11322.2.camel@intel.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
	 <1437056730-15247-3-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-3-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> Add get variable and set variable function to EFI services pointer
> table for supporting later functions of hibernate signature
> verification to keep the HMAC key in efi boot service veriable.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

Maybe mention that we want to be able to read/write variables from
within the EFI boot stub? That's really why you want to add
{get,set}_variable pointers.

s/veriable/variable/

Rest of the patch looks good.

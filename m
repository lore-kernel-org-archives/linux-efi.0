From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 07/16] efi: Make efi_status_to_err() public
Date: Thu, 20 Aug 2015 16:07:06 +0100
Message-ID: <20150820150706.GE2567@codeblueprint.co.uk>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-8-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439273796-25359-8-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Aug, at 02:16:27PM, Lee, Chun-Yi wrote:
> Moved the function of transferring EFI status to kernel error for
> later used by EFI stub.
 
Might I suggest:

 "Move the function for converting EFI status to kernel error values
  from drivers/firmware/efi/ to include/linux/efi.h for use by the x86
  EFI stub in an upcoming patch."

?

> Reviewed-by: Jiri Kosina <jkosina@suse.com>
> Tested-by: Jiri Kosina <jkosina@suse.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/firmware/efi/vars.c | 33 ---------------------------------
>  include/linux/efi.h         | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 33 deletions(-)

The patch content is fine,

Reviewed-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center

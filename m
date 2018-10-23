From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH] efi: Fix debugobjects warning on efi_rts_work
Date: Tue, 23 Oct 2018 16:43:29 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485D622C@ORSMSX114.amr.corp.intel.com>
References: <1540304307-2806-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540304307-2806-1-git-send-email-longman@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Waiman Long <longman@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org



> -----Original Message-----
> From: Waiman Long [mailto:longman@redhat.com]
> Sent: Tuesday, October 23, 2018 7:18 AM
> To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org; Prakhya, Sai
> Praneeth <sai.praneeth.prakhya@intel.com>; Waiman Long
> <longman@redhat.com>
> Subject: [PATCH] efi: Fix debugobjects warning on efi_rts_work
> 
> The commit 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault
> handler") converted efi_rts_work from an auto variable to a global variable.
> However, when submitting the work, INIT_WORK_ONSTACK() was still used
> causing the following complaint from debugobjects:
> 
> ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760, but
> annotated.
> 
> Change the macro to just INIT_WORK() to eliminate the warning.
> 
> Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault
> handler")

Thanks for fixing this :)
Looks good to me.

Regards,
Sai

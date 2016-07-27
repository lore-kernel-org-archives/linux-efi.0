From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 4/4] x86/efi: Use efi_exit_boot_services()
Date: Wed, 27 Jul 2016 12:51:21 -0600
Message-ID: <7f331474-6707-82ef-8e75-55981bec3adb@codeaurora.org>
References: <1469132894-17103-1-git-send-email-jhugo@codeaurora.org>
 <1469132894-17103-5-git-send-email-jhugo@codeaurora.org>
 <20160727180839.GJ31759@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727180839.GJ31759-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 7/27/2016 12:08 PM, Matt Fleming wrote:
> On Thu, 21 Jul, at 02:28:14PM, Jeffrey Hugo wrote:
>> The eboot code directly calls ExitBootServices.  This is inadvisable, and
>> the eboot code attempts allocations after calling ExitBootSerives which is
>> not permitted per the spec.  The efi_exit_boot_services() helper handles
>> this scenario.
>>
>> Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c | 130 ++++++++++++++++++++-------------------
>>  1 file changed, 67 insertions(+), 63 deletions(-)
>
> FYI, this patch prevents my x86-64 test machines from booting. Of
> course, because it's the early boot code there's no useful output on
> the console other than "efi_main() failed!".
>
> I'll debug further tomorrow.
>

Doh.  I'm sorry for that.  Clearly my limited x86 testing was 
insufficient.  I'll see if I reproduce on my end for parallel debug.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.

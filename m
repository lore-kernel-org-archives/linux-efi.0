From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] EFI merge botch fix
Date: Tue, 30 Apr 2013 07:57:32 -0700
Message-ID: <7b4ef246-c442-45e6-bc1e-0e1821f8fad9@email.android.com>
References: <20130429181819.GA2254@console-pimps.org> <20130430084731.GB21473@gmail.com> <517FB0F6.9030103@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517FB0F6.9030103-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Yes, please send pull requests.

Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

>On 30/04/13 09:47, Ingo Molnar wrote:
>> The other problem is that tip:x86/efi also conflicts with current
>-git, as 
>> of v3.9 - due to interaction with an EFI fix tree ...
>> 
>> This is getting ugly pretty fast, so I'd suggest to re-do the merges 
>> cleanly, not by rebasing the tree, but by redoing the first merge in 
>> essence:
>> 
>>   e29c2de5f591 Merge tag 'v3.9-rc8' into efi-for-tip
>> 
>> By correctly merging v3.9-final into f53f292 - making sure the
>changes to 
>> drivers/firmware/efivars.c correctly merge over, and making sure the
>ia64 
>> select does not get lost.
>> 
>> Something like this would do:
>> 
>>   git checkout -b x86-new-efi-branch f53f292
>>   git merge v3.9
>>   < ... resolve all the conflicts ...>
>>   git commit
>> 
>> I can then (non-fast-forward) fetch this new EFI branch as the new 
>> tip:x86/efi.
>
>OK, I re-did the merge against v3.9 as requested and published it as
>'efi-for-tip2'. Would you like me to send a proper pull request if
>that's easier to pull into the tip machinery?
>
>I have also started accumulating fixes against the EFI changes in
>tip/x86/efi. Would you like those as a separate pull request? The fixes
>branch is 'efi-for-tip-fixes' and is based on the above merge branch,
>'efi-for-tip2'. It mainly includes fixes for bugs in the pstore paths
>which Seiji Aguchi found.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

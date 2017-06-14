From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 23/34] x86, realmode: Decrypt trampoline area if memory
 encryption is active
Date: Wed, 14 Jun 2017 11:38:57 -0500
Message-ID: <dffd4702-9598-40ef-c9ad-ef970df13e32@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
 <20170607191709.28645.69034.stgit@tlendack-t1.amdoffice.net>
 <20170614162416.ksa54esy5ql7sjgz@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614162416.ksa54esy5ql7sjgz-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy
List-Id: linux-efi@vger.kernel.org

On 6/14/2017 11:24 AM, Borislav Petkov wrote:
> On Wed, Jun 07, 2017 at 02:17:09PM -0500, Tom Lendacky wrote:
>> When Secure Memory Encryption is enabled, the trampoline area must not
>> be encrypted. A CPU running in real mode will not be able to decrypt
>> memory that has been encrypted because it will not be able to use addresses
>> with the memory encryption mask.
>>
>> A recent change that added a new system_state value exposed a warning
>> issued by early_ioreamp() when the system_state was not SYSTEM_BOOTING.
>> At the stage where the trampoline area is decrypted, the system_state is
>> now SYSTEM_SCHEDULING. The check was changed to issue a warning if the
>> system_state is greater than or equal to SYSTEM_RUNNING.
> 
> This piece along with the hunk touching system_state absolutely needs to
> be a separate patch as it is unrelated.

Yup, will do.

Thanks,
Tom

> 

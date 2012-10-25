From: Mike Waychison <mikew@google.com>
Subject: Re: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from a
 write callback to hold multiple logs
Date: Thu, 25 Oct 2012 14:19:59 -0700
Message-ID: <CAGTjWtDEQx8mCKtNTGGSOMajAoSCJTaKWG8TBmYinQMPfx5DQQ@mail.gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
 <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413889851@USINDEM103.corp.hds.com>
 <CAGTjWtAUv=HzOGPDeDuTb_6z81bnSQ-F7DDERZ2tqmfaP4wXwQ@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D413889905@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413889905@USINDEM103.corp.hds.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 25, 2012 at 1:51 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
>> So doesn't this break erasing of existing dumps in pstore-efivars?
>> Unless efi_pstore_read still understands the older variable name formats, users will be stranded with dumps consuming space in
>> efivars that aren't exported via pstore anymore.
>
> Patch 2/5, 3/5 and 4/5 don't change an existing format of a variable name and don't break anything.
> The existing format consists of type, id and ctime. And it is not moditied by these patches.
> Here is a variable name (and guid) of efi_pstore in curret linus-tree.
>
>         ls /sys/firmware/efi/vars/
>         dump-type0-1-1351113059-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>         dump-type0-2-1351113059-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>         dump-type0-3-1351113059-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>
>         Variable Name: dump-type0-1-1351113059
>         GUID: cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0

Okay, this alleviates most of my concerns for ctime.

>
> On the other hand, patch 5/5 changes the format by adding sequence counter.
> But efi_pstore_read is modied to work correctly in it.
>
>         dump-type0-1-1-1351113059-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>
>         Variable Name: dump-type0-1-1-1351113059
>         GUID: cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>
> If I need to elaborate more, please feel free to ask me:)
> I'm not sure if I understand your question completely.

In this case, I think efi_pstore_read in patch 5/5 should probably
fall-back to trying to do a sscanf(...) == 3 if the sscanf(...) == 4
test fails so that dumps for older dumps from previous kernels are
still visible to users, no?  They can perhaps get a default count of
0?  efi_pstore_erase would have to be updated to understand this as
well.

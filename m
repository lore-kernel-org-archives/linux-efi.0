From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v6 26/34] iommu/amd: Allow the AMD IOMMU to work with memory encryption
Date: Thu, 15 Jun 2017 16:13:29 -0400
Message-ID: <C1A52990-84AA-4258-B864-0121F5F5C4B5@oracle.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net> <20170607191745.28645.81756.stgit@tlendack-t1.amdoffice.net> <20170614174208.p2yr5exs4b6pjxhf@pd.tnic> <0611d01a-19f8-d6ae-2682-932789855518@amd.com> <20170615094111.wga334kg2bhxqib3@pd.tnic> <921153f5-1528-31d8-b815-f0419e819aeb@amd.com> <20170615153322.nwylo3dzn4fdx6n6@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170615153322.nwylo3dzn4fdx6n6@pd.tnic>
Sender: owner-linux-mm@kvack.org
To: Borislav Petkov <bp@alien8.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey
List-Id: linux-efi@vger.kernel.org

On June 15, 2017 11:33:22 AM EDT, Borislav Petkov <bp@alien8=2Ede> wrote:
>On Thu, Jun 15, 2017 at 09:59:45AM -0500, Tom Lendacky wrote:
>> Actually the detection routine, amd_iommu_detect(), is part of the
>> IOMMU_INIT_FINISH macro support which is called early through
>mm_init()
>> from start_kernel() and that routine is called before init_amd()=2E
>
>Ah, we do that there too:
>
>	for (p =3D __iommu_table; p < __iommu_table_end; p++) {
>
>Can't say that that code with the special section and whatnot is
>obvious=2E :-\
>

Patches to make it more obvious would be always welcome!



Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

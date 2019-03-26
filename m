From: Boris Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/2 v8] resource: add the new I/O resource descriptor 'IORES_DESC_RESERVED'
Date: Tue, 26 Mar 2019 10:58:31 +0100
Message-ID: <5B077919-37B4-4434-86BC-6F29DD73C195@alien8.de>
References: <20181129080956.20776-1-lijiang@redhat.com> <20181129080956.20776-2-lijiang@redhat.com> <20181130033703.GA23624@dhcp-128-65.nay.redhat.com> <b8936194-01ef-8b8f-254e-039fc951855d@amd.com> <95661569-d9c9-af13-11c4-c0d752710a1f@redhat.com> <b1556461-fe83-2ba0-00a3-e8ecf3e286fe@amd.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b1556461-fe83-2ba0-00a3-e8ecf3e286fe@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, lijiang <lijiang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "tony.luck@intel.com" <tony.luck@intel.com>, "fenghua.yu@intel.com" <fenghua.yu@intel.com>, "bhe@redhat.com" <bhe@redhat.com>, Toshi
List-Id: linux-efi@vger.kernel.org

On March 25, 2019 8:34:25 PM GMT+01:00, "Lendacky, Thomas" <Thomas=2ELendac=
ky@amd=2Ecom> wrote:
>On 3/16/19 2:31 AM, lijiang=20
>Adding a nice comment here about how IORES_DESC_NONE originally was to
>identify MMIO and reserved areas=2E Now IORES_DESC_RESERVED has been
>created
>for the reserved areas so the check needs to be expanded

Expanded and made explicit *which* areas should not be mapped encrypted an=
d then the function name corrected=2E=20

Thx=2E

--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 

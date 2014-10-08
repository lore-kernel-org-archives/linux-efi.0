From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_08/44]_kernel:_Mov?=
 =?utf-8?Q?e_pm=5Fpower=5Foff_to_common_code?=
Date: Wed, 8 Oct 2014 19:06:32 +0800 (CST)
Message-ID: <218135571.28324.1412766392198.JavaMail.root@bj-mail03.pku.edu.cn>
References: <1412659726-29957-9-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1412659726-29957-9-git-send-email-linux@roeck-us.net>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, adi-buildroot-devel@lists.sourceforge.net, devel@driverdev.osuosl.org, devicetree@vger.kernel.org, lguest@lists.ozlabs.org, linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org, linux-am33-list@redhat.com, linux-cris-kernel@axis.com, linux-efi@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org, linux-xtensa@linux-xtensa.org, openipmi-developer@lists.sourceforge.net, user-mode-linux-devel@lists.sourceforge.net, linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org, linux-m68k@vger.kernel.org, linux-metag@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-pm@vg
List-Id: linux-efi@vger.kernel.org


----- Guenter Roeck <linux@roeck-us.net> =E5=86=99=E9=81=93=EF=BC=9A
> pm_power_off is defined for all architectures. Move it to common code=
=2E
>=20
> Have all architectures call do_kernel_poweroff instead of pm_power_of=
f.
> Some architectures point pm_power_off to machine_power_off. For those=
,
> call do_kernel_poweroff from machine_power_off instead.
>=20

=46or UniCore32 part,

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

Thanks
Xuetao

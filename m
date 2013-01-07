From: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] Fix efifb initialisation when the only GOP device
 implements ConOut.
Date: Mon, 07 Jan 2013 17:51:20 +0000
Message-ID: <1357581080.2844.17.camel@shinybook.infradead.org>
References: <1357431222.9270.73.camel@shinybook.infradead.org>
	 <1357524250.9270.86.camel@shinybook.infradead.org>
	 <1357578923.8203.72.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature";
	boundary="=-86T6zooNpA1TN67k25FP"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357578923.8203.72.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--=-86T6zooNpA1TN67k25FP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-07 at 17:15 +0000, Matt Fleming wrote:
> On Mon, 2013-01-07 at 02:04 +0000, David Woodhouse wrote:
> > On Sun, 2013-01-06 at 00:13 +0000, David Woodhouse wrote:
> > > When booting under OVMF we have precisely one GOP device, and it
> > > implements the ConOut protocol.
> > >=20
> > > We break out of the loop when we look at it... and then promptly abor=
t
> > > because 'first_gop' never gets set.
> >=20
> > Hmmm. I've just fixed OVMF so that when qemu is invoked with the
> > '-kernel' argument, it uses the EFI handover protocol. And now graphics
> > is broken on kernels *without* this patch. I can't even initialise the
> > graphics info in OVMF (as it does for non-EFI handover) because the
> > kernel helpfully zeroes it all out before failing to set it up
> > correctly.
> >=20
> > Does it make sense to bump the boot protocol to 2.12 to indicate that
> > this bug is fixed, and then let things like OVMF use the EFI handover
> > protocol only for boot protocol >=3D 2.12? Or is there a better way...?
>=20
> Bumping the boot protocol seems like a sensible idea.
>=20
> Peter, any objection to that?

I'd like to fix the 32-bit EFI entry point first. Although the PE entry
point helpfully adds 4 to $esp to effectively pop the unwanted return
address off the stack, the EFI entry point at 0x30 doesn't. So I'm doing
this for now to test OVMF, while I work out why the EFI stub is then
crashing in the PCI ROM handling:

--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -50,8 +50,10 @@ ENTRY(startup_32)
        pushl   %eax
        pushl   %esi
        pushl   %ecx
+       pushl   %ecx
=20
        .org 0x30,0x90
+       add     $0x4, %esp
        call    efi_main
        cmpl    $0, %eax
        movl    %eax, %esi

On fact, the whole 32-bit vs 64-bit entry point seems entirely
confusing.

It seems that a bootloader needs to *know* whether it's loading a 64-bit
or a 32-bit kernel image. A quick check shows that grub is always
running non-EFI kernels in 32-bit mode, at the 32-bit entry point. So
that's fine. But for the EFI stub, a 64-bit grub unconditionally jumps
to the undocumented=C2=B9 0x200 + handover_offset, while a 32-bit grub omit=
s
the 0x200. So if you attempt to boot a 64-bit kernel from a 32-bit grub,
or vice versa, it's just going to crash.

What is the bootloader *supposed* to do?

--=20
dwmw2
=C2=B9 Not strictly true. It's documented as "THIS MAY CHANGE. BOOTLOADERS
  SHALL USE THE ELF HEADERS TO FIND IT" in .../boot/compressed/head_64.S

--=-86T6zooNpA1TN67k25FP
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUbjCCBjQw
ggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAn
BgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3MTAyNDIxMDE1NVoX
DTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSsw
KQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFy
dENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOrlr6KMoOMpohBllVHrdRvEg/q6r8jR+EK
75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSMzR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC
+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxD
z2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSDkOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr
/+N2JLKutIxMYqQOJebr/f/h5t95m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0w
ggGpMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFc
fH6WNU7y1LhRgjAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRa
MFgwJwYIKwYBBQUHMAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYh
aHR0cDovL3d3dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqDCH14qywG
XLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy6QMVQjbbMXlt
UfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPIzKKR9tQW8gGK+2+R
HxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKfKSETEPrHh7p5shuuNktv
sv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HORz9v3vQwR4e3ksLc2JZOAFK+s
sS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9sIPP7ON0fz095HdThKjiVJe6vofq
+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCieuoBJ9OlqmsVWQvifIYf40dJPZkk9YgGT
zWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7tw1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGq
Up/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQG2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb1
9mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIHFzCCBf+g
AwIBAgIDBCZ6MA0GCSqGSIb3DQEBBQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcN
MTIwNTAxMTI1ODI3WhcNMTMwNTAzMTEzNzIwWjBdMRkwFwYDVQQNExA4Y1VOSzUzMTc0ODRYRjk3
MRwwGgYDVQQDDBNkd213MkBpbmZyYWRlYWQub3JnMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZy
YWRlYWQub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyYe7wo6MrtrB4uIGGbrY
4IifY/Xsq22pSv605yganL0+uyUdd8rCjrYlH6Q/ra5TVJCQFTgzaepkuqPQc79DC/Cxmzm6Qo+s
wLZy868oFsccsVokL2bPAWIPaRXfNPJKkYR1FTWQfZpWJVQmT+sPf1XFUullVBAK+d9RztopyacI
xWoZ/W/Cmv7mseQbttYTtGKJa0btX73nsQRWl6SgErWXo59zg9friCLTy1GXMXJYB8H+PtnuwX0w
MrAvWDdX1ABgIlA17W3FraCn0eW15ZM46eyu0/amGzJZNtemCWF73P7BAijzeV1jNmiJFXdZ0DT0
w+hmtMO9PxdDUyt78QIDAQABo4IDrjCCA6owCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBTkfe5UOr3PcirsjApibyyUEfsyRzAf
BgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y1LhRgjAeBgNVHREEFzAVgRNkd213MkBpbmZyYWRl
YWQub3JnMIICIQYDVR0gBIICGDCCAhQwggIQBgsrBgEEAYG1NwECAjCCAf8wLgYIKwYBBQUHAgEW
Imh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0
Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBp
c3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9m
IHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBw
dXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMIGc
BggrBgEFBQcCAjCBjzAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgECGmRM
aWFiaWxpdHkgYW5kIHdhcnJhbnRpZXMgYXJlIGxpbWl0ZWQhIFNlZSBzZWN0aW9uICJMZWdhbCBh
bmQgTGltaXRhdGlvbnMiIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3kuMDYGA1UdHwQvMC0wK6Ap
oCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGB
MH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MxL2NsaWVu
dC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNz
MS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkq
hkiG9w0BAQUFAAOCAQEAqDU1FKifNtCFJbLnvOi1BLRfk7mut55PMtPSZLJ4/AnG7AjmJnbBI4U5
DELwvVq3mIpwUpGqZUkqkZMEfBPIbfq517UZB3h4iANtqif+ULfTLhg5XgcK5eF8/T6EtX2c3epq
ylARdleCbj/0FwiUDvPlTsA6PIN4SCekjRLgjKERrL3heFz+Hteq1rtMAvMkNuyL0/0ijyyg2y45
NASAl2Afl9SLes/fnoh9nBwzfNQfb6qDYUFpnglfpGrq/0b1NtaOUb2z1SR+H1tKlb8bVJJIdvpu
mEi27kSRIhzk3h30uTfKkKetgy++ouyldxZ7KZ0PuoLQrBy465EoQLosETCCBxcwggX/oAMCAQIC
AwQmejANBgkqhkiG9w0BAQUFADCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0
ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMT
L1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBMB4XDTEyMDUw
MTEyNTgyN1oXDTEzMDUwMzExMzcyMFowXTEZMBcGA1UEDRMQOGNVTks1MzE3NDg0WEY5NzEcMBoG
A1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFk
Lm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMmHu8KOjK7aweLiBhm62OCIn2P1
7KttqUr+tOcoGpy9PrslHXfKwo62JR+kP62uU1SQkBU4M2nqZLqj0HO/QwvwsZs5ukKPrMC2cvOv
KBbHHLFaJC9mzwFiD2kV3zTySpGEdRU1kH2aViVUJk/rD39VxVLpZVQQCvnfUc7aKcmnCMVqGf1v
wpr+5rHkG7bWE7RiiWtG7V+957EEVpekoBK1l6Ofc4PX64gi08tRlzFyWAfB/j7Z7sF9MDKwL1g3
V9QAYCJQNe1txa2gp9HlteWTOOnsrtP2phsyWTbXpglhe9z+wQIo83ldYzZoiRV3WdA09MPoZrTD
vT8XQ1Mre/ECAwEAAaOCA64wggOqMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdJQQWMBQG
CCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU5H3uVDq9z3Iq7IwKYm8slBH7MkcwHwYDVR0j
BBgwFoAUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiEGA1UdIASCAhgwggIUMIICEAYLKwYBBAGBtTcBAgIwggH/MC4GCCsGAQUFBwIBFiJodHRw
Oi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRwOi8vd3d3LnN0
YXJ0c3NsLmNvbS9pbnRlcm1lZGlhdGUucGRmMIH3BggrBgEFBQcCAjCB6jAnFiBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+VGhpcyBjZXJ0aWZpY2F0ZSB3YXMgaXNzdWVk
IGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMSBWYWxpZGF0aW9uIHJlcXVpcmVtZW50cyBvZiB0aGUg
U3RhcnRDb20gQ0EgcG9saWN5LCByZWxpYW5jZSBvbmx5IGZvciB0aGUgaW50ZW5kZWQgcHVycG9z
ZSBpbiBjb21wbGlhbmNlIG9mIHRoZSByZWx5aW5nIHBhcnR5IG9ibGlnYXRpb25zLjCBnAYIKwYB
BQUHAgIwgY8wJxYgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwAwIBAhpkTGlhYmls
aXR5IGFuZCB3YXJyYW50aWVzIGFyZSBsaW1pdGVkISBTZWUgc2VjdGlvbiAiTGVnYWwgYW5kIExp
bWl0YXRpb25zIiBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LjA2BgNVHR8ELzAtMCugKaAnhiVo
dHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9jcnR1MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkG
CCsGAQUFBzABhi1odHRwOi8vb2NzcC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2Ew
QgYIKwYBBQUHMAKGNmh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEuY2xp
ZW50LmNhLmNydDAjBgNVHRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcN
AQEFBQADggEBAKg1NRSonzbQhSWy57zotQS0X5O5rreeTzLT0mSyePwJxuwI5iZ2wSOFOQxC8L1a
t5iKcFKRqmVJKpGTBHwTyG36ude1GQd4eIgDbaon/lC30y4YOV4HCuXhfP0+hLV9nN3qaspQEXZX
gm4/9BcIlA7z5U7AOjyDeEgnpI0S4IyhEay94Xhc/h7Xqta7TALzJDbsi9P9Io8soNsuOTQEgJdg
H5fUi3rP356IfZwcM3zUH2+qg2FBaZ4JX6Rq6v9G9TbWjlG9s9Ukfh9bSpW/G1SSSHb6bphItu5E
kSIc5N4d9Lk3ypCnrYMvvqLspXcWeymdD7qC0KwcuOuRKEC6LBExggNvMIIDawIBATCBlDCBjDEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdp
dGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFy
eSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMEJnowCQYFKw4DAhoFAKCCAa8wGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTMwMTA3MTc1MTIwWjAjBgkqhkiG9w0BCQQx
FgQUKD88vmgpHCK7691xSy2rh4r2r3wwgaUGCSsGAQQBgjcQBDGBlzCBlDCBjDELMAkGA1UEBhMC
SUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRp
ZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1l
ZGlhdGUgQ2xpZW50IENBAgMEJnowgacGCyqGSIb3DQEJEAILMYGXoIGUMIGMMQswCQYDVQQGEwJJ
TDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlm
aWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVk
aWF0ZSBDbGllbnQgQ0ECAwQmejANBgkqhkiG9w0BAQEFAASCAQCjZ+32M/wYOhBck9XDYW/VwlLp
Y64TqkZCx1obIXHES3+ZKt8qDnvsXC6DjVPb08wVfCOdAfPsueZURHp8FVdtPq+J2Rlu6k/SH7/9
QLRtRNdu8vXvZNmJ0jw/Wdaie4GieyUmFmg9mOaJrbUwVWNTMCFmSVZKzA0tcGayu7YMbdplGlq6
RPb+bOzXy+HAFtZdXPVrqPAiZ1kQYOohlR1NAHmyuYCP5Y1BVUdX7kcKgojLfdfZJ01tPz6lhonL
G0hdZCYhNKcjr19Lz5E/lTWKYzNG3zXBsU8FD9IFEIW3hYCixpXWcPQZyg2GRKfgPyE6w603vkVm
s/ynyLBSm4E2AAAAAAAA


--=-86T6zooNpA1TN67k25FP--

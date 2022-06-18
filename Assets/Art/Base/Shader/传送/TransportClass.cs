using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransportClass : MonoBehaviour
{
    //�������
    //transportֵ��-3��ֵ��5,WarpDirֵΪ(0,0,70),SlashMaxֵΪ10
    //Position���ܽⷽ��λ��X����
    //transportֵ��-5��ֵ��3,WarpDirֵΪ(0,0,-70),SlashMaxֵΪ-10

    public AnimationCurve amc;
    public float time;
    public Material mat;
    public float transportPoint = 0.5f;
    public float slashMax = 0.5f;
    public Vector3 direction = new Vector3(0, 0, 1);
    public float transportDistance = 1;
    public GameObject Effect;
    //public GameObject targetB;
    public Camera cam;
    public float rotateSpeed = 0.2f;
    public float speed = 1;
    public Transform cameradir;


    bool doOnce;
    float amct;
    float t;
    bool isdown = false;


    void Update()
    {
        //���ڴ��͹�����,λ��,����,��ת������ֹ
        if(isdown == false )//���ڴ��͹�����,��ִ��
        {

        //λ��
        transform.position += Input.GetAxis("Horizontal") * cameradir.right * speed;
        transform.position += Input.GetAxis("Vertical") * cameradir.forward * speed;

        //����
        //1.��ȡ�������ʹ���������ScreenPointToRay����������һ��Ray����
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);

        //2.ʹ��RaycastʹRay���߷�����ײ,������ײ������Outһ��������Ϣhitinfo
        //  Physics.raycast(��,������Ϣ���,����ײ����,��Mask)
        Physics.Raycast(ray, out RaycastHit infohit, 1500, LayerMask.GetMask("plane"));

        //3.������Ϣ��,��ȡ���ĵ�(point,�������е�position)
        Vector3 hitposition = infohit.point;

        //4.ʹ����ײ����Ϊ��������B��
        Vector3 target = Vector3.Normalize(hitposition - this.transform.position);//���峯�����ķ���
        transform.forward = Vector3.Lerp(transform.forward, target, rotateSpeed);

        }


        //����
        if (Input.GetMouseButtonDown(0))
        {
            Effect.SetActive(false);
            doOnce = true;
            isdown = true;
            t = 0;
        }
        if (isdown == true)
        {
            Effect.SetActive(true);
            t += Time.deltaTime / time;//t��һ��0��1��ֵ
            t = Mathf.Clamp(t, 0, 1);
            amct = amc.Evaluate(t);
            mat.SetFloat("_Transport", amct);
        }
        if(t < transportPoint)
        {
            mat.SetFloat("_SlashMax", slashMax);
            mat.SetVector("_WarpDir", direction);
        }
        if (t >= transportPoint)
        {
            if(doOnce == true)
            {
                transform.position += transportDistance * transform.forward;
                doOnce = false;
            }
            mat.SetFloat("_SlashMax", -slashMax);
            mat.SetVector("_WarpDir", -direction);
        }
        if(t>=1)
        {
            isdown = false;
        }
    }
}
